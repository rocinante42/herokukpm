class BubbleGroupStatus < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  belongs_to :poset
  belongs_to :classroom
  belongs_to :general, class_name: 'BubbleGroupStatus', foreign_key: 'general_id'
  has_many :sub_bubble_group_statuses, class_name: 'BubbleGroupStatus', foreign_key: 'general_id'
  has_many :kid_activities

  has_many :bubble_statuses, dependent: :destroy
  has_many :triggers, through: :bubble_group

  scope :general, -> {where(kid:nil)}
  scope :none_status, -> {where(active:ACTIVE_NONE)}
  scope :active, -> {where(active:ACTIVE_ACTIVE)}
  scope :inactive, -> {where(active:ACTIVE_INACTIVE)}

  alias :current_poset :poset

  ## active allowed values
  ACTIVE_VALUES = [
    ACTIVE_NONE = 0,
    ACTIVE_ACTIVE = 1,
    ACTIVE_INACTIVE = 2
  ]

  ACTIVE_HUMAN_NAMES = {
    ACTIVE_NONE => 'None',
    ACTIVE_ACTIVE => 'Active',
    ACTIVE_INACTIVE => 'Inactive'
  }

  ACTIVE_SELECT_OPTIONS = ACTIVE_HUMAN_NAMES.invert.to_a

  ## validations
  validates :active, inclusion: ACTIVE_VALUES

  ## ensure that the bubble group status is fully formed after creation
  after_create :reset!
  after_save :track_activity
  after_create :create_sub_bg_statuses, if: Proc.new{ |bg_status| bg_status.general? }
  after_update :update_all_sub_bg_statuses, if: Proc.new{ |bg_status| bg_status.general? }

  def active?
    case self.active
    when ACTIVE_ACTIVE
      return true
    when ACTIVE_INACTIVE
      return false
    else
      return true if self.bubble_statuses.passed.count > 0
      bubble_ids = self.bubble_group.triggers.pluck(:bubble_id).uniq
      unpassed_triggers = self.kid.bubble_statuses.where(bubble_id: bubble_ids).passed

      return (unpassed_triggers.count == bubble_ids.count)
      #bubble_ids = self.bubble_group.bubbles.joins(:triggers).where(triggers: { bubble_group: self.bubble_group }).in_category(classroom_categories).ids.uniq
      #unpassed_triggers = self.kid.bubble_statuses.where(bubble_id: bubble_ids).passed

      #return (unpassed_triggers.count == bubble_ids.count)
    end
  end

  def human_active_string
    ACTIVE_HUMAN_NAMES[self.active]
  end

  ## accessors for information about the current poset
  def current_poset_type
    case poset_id
    when bubble_group.full_poset_id
      "Full"
    when bubble_group.forward_poset_id
      "Forward"
    when bubble_group.backward_poset_id
      "Backward"
    else
      "Unknown"
    end
  end

  def previous_poset
    case current_poset_type
    when "Full"
      bubble_group.backward_poset
    when "Forward"
      bubble_group.full_poset
    when "Backward"
      bubble_group.backward_poset
    else
      nil
    end
  end

  def next_poset
    case current_poset_type
    when "Full"
      bubble_group.forward_poset
    when "Forward"
      bubble_group.forward_poset
    when "Backward"
      bubble_group.full_poset
    else
      nil
    end
  end

  ## standardized result handler
  def safe_handle_result!(bubble_status, result)
    ## check that this bubble could have been played
    self.handle_result!(bubble_status, result) if self.available_bubbles.exists?(id: bubble_status.id)
  end

  def handle_result!(bubble_status, result)
    case result
    when 'pass'
      self.pass! bubble_status
    when 'fail'
      self.fail! bubble_status
    when 'enjoy'
      self.enjoy! bubble_status
    end
  end

  ## sets up the statuses on all bubbles for the bubble group
  def reset!
    ## this should all be done in a single transaction, since we should do everything or nothing
    ActiveRecord::Base.transaction do
      ## reset the counters and the poset
      self.classroom ||= kid.try(:classroom)
      self.pass_counter = 0
      self.fail_counter = 0
      self.poset = self.bubble_group.full_poset
      self.save!

      ## reset the bubble statuses for each bubble
      self.bubble_group.bubbles.each do |bubble|
        status = self.bubble_statuses.find_or_initialize_by(bubble: bubble)
        status.reset
        status.save!
      end

      ## activate the minima
      self.poset.minima.each do |bubble|
        status = self.bubble_statuses.find_by(bubble: bubble)
        status.active = true
        status.save!
      end
    end
  end

  ## traversal methods
  def pass bubble_status
    ## adjust the counters
    self.fail_counter = 0
    self.pass_counter += 1

    ## pass this bubble
    bubble_status.passed = true
    bubble_status.save

    ## backward moves back to the full
    if current_poset_type == "Backward"
      self.pass_counter = 0

      self.poset = self.bubble_group.full_poset
      clean_bubbles_backward
    else
      ## activate all required nodes in the current poset
      activation_check(bubble_status)

      ## activate and pass all necessary nodes in the full set, and check successors for activation
      bubble_status.downset(self.bubble_group.full_poset).where('passed = (?) OR active = (?) OR id = (?)', false, true, bubble_status.id).each do |status|
        status.update_columns(passed: true, active: false)
        check_predecessors(status.successors(self.bubble_group.full_poset).failed, self.bubble_group.full_poset)
      end

      ## if the bubble is a maximal, reactivate it
      if bubble_status.successors(nil).count == 0
        bubble_status.update_columns( active: true )
      end

      ## switch poset, if necessary and possible
      if self.pass_counter >= self.current_poset.pass_threshold
        next_poset = self.next_poset
        unless self.current_poset == next_poset
          ## reset the pass counter and move to the next poset
          self.pass_counter = 0
          self.poset = next_poset

          case current_poset_type
          when "Forward"
            activate_min_failed
          end
        end
      end
    end
  end

  def fail bubble_status
    ## adjusts the counters
    self.pass_counter = 0
    self.fail_counter += 1

    ## if in forward poset, only need to fail current bubble, cleanup bubbles, and switch to full
    if current_poset_type == "Forward"
      self.fail_counter = 0

      bubble_status.passed = false
      bubble_status.save

      clean_bubbles_forward

      self.poset = self.bubble_group.full_poset
    else
      ## fail and deactivate everything in the upset
      bubble_status.upset(self.bubble_group.full_poset).update_all(passed: false, active: false)
      bubble_status.reload

      ## if this bubble is a minimum, reactivate it
      if bubble_status.predecessors(nil).count == 0
        bubble_status.active = true
        bubble_status.save!
      end

      ## activate all predecessors
      bubble_status.predecessors(nil).each do |predecessor|
        predecessor.update( active: true )
      end

      ## activate all required nodes in the full poset
      if self.poset != self.bubble_group.full_poset
        bubble_status.predecessors(self.bubble_group.full_poset).each do |predecessor|
          predecessor.update( active: true )
        end
      end

      ## switch poset, if necessary
      if self.fail_counter >= self.current_poset.fail_threshold
        prev_poset = self.previous_poset
        unless self.poset == prev_poset
          self.fail_counter = 0
          self.poset = prev_poset
          ## additional processing for tranfers
          case current_poset_type
          when "Backward"
            activate_max_passed
          end
        end
      end
    end
  end

  def enjoy bubble_status
    ## adjust the counters
    self.pass_counter = 0
    self.fail_counter = 0
  end

  ## traversal methods with saves
  def pass! bubble_status
    self.pass bubble_status
    self.save!
  end

  def fail! bubble_status
    self.fail bubble_status
    self.save!
  end

  def enjoy! bubble_status
    self.enjoy bubble_status
    self.save!
  end

  ## select a bubble for the kid to play
  def available_bubbles
    ## get statuses of currently available bubbles
    #bubbles = self.bubble_statuses.where(bubble: self.current_poset.bubbles.in_category(classroom_categories)).active
    bubbles = self.bubble_statuses.where(bubble: self.current_poset.bubbles).active
    ## refine the bubbles, if possible
    case current_poset_type
    when "Forward"
      refined_bubbles = bubbles.where(passed: false)
      bubbles = refined_bubbles unless refined_bubbles.count == 0
    when "Backward"
      refined_bubbles = bubbles.where(passed: true)
      bubbles = refined_bubbles unless refined_bubbles.count == 0
    end

    ## return the available bubbles
    bubbles
  end

  def track_activity
    sub_statuses = general? ? sub_bubble_group_statuses : [self]
    sub_statuses.each(&:single_track_activity)
  end

  def single_track_activity
    kid_activities.last.touch if (inactive? || none?) && kid_activities.any?
    kid_activities.create if active?
  end

  def time_left_in_seconds
    sub_statuses = general? ? sub_bubble_group_statuses : [self]
    sub_statuses.map(&:single_time_left_in_seconds).inject(:+)
  end

  def single_time_left_in_seconds
    last_activity_progress = active? ? Time.now - kid_activities.last.created_at : 0
    ((time_limit || 2.hours) - kid_activities.map(&:total_time).inject(:+) - last_activity_progress)
  end

  def expired?
    time_left_in_seconds <= 0
  end

  def general?
    kid.nil?
  end

  def none?
    active == ACTIVE_NONE
  end

  def inactive?
    active == ACTIVE_INACTIVE
  end

  def create_sub_bg_statuses
    classroom.students.each do |kid|
      bubble_group_status = sub_bubble_group_statuses.where(bubble_group: bubble_group, kid:kid, classroom: classroom).first_or_initialize
      if bubble_group_status.new_record?
        bubble_group_status.active = ACTIVE_ACTIVE
        bubble_group_status.time_limit = time_limit
        bubble_group_status.general = self
        bubble_group_status.save!
      end
    end
  end

  def update_all_sub_bg_statuses
    sub_bubble_group_statuses.update_all(active:self.active)
  end

  def humanized_status
    active ==  ACTIVE_ACTIVE ? 'Selected' : 'Not Selected'
  end

  private
    def classroom_categories

      classroom.classroom_type.bubble_categories.ids
    end

    ## check the predecessors in the passed in collection and activate if all predecessors passed
    def check_predecessors(statuses, poset)
      statuses.each do |status|
        unless status.predecessors(poset).exists?( passed: false )
          status.active = true
          status.save!
        end
      end
    end

    def activation_check(bubble_status)
      ## get active bubbles in the downset
      statuses = bubble_status.downset(self.current_poset).active

      ## deactivate and check successors for each of those
      statuses.each do |status|
        status.active = false
        status.save!

        ## activate if failed and predecessors are all passed
        check_predecessors(status.successors(nil).failed, self.current_poset)
      end
    end

    ## activate the minimum failed nodes in the current poset
    def activate_min_failed(poset = nil)
      ## default to the current poset
      poset ||= self.current_poset

      ## fetch the failed bubble statuses in that poset
      failed = self.bubble_statuses.where(bubble: poset.bubbles.in_category(classroom_categories)).where(passed: false)

      ## activate nodes where all predecessors in that poset are passed
      check_predecessors(failed, poset)
    end

    ## activate the maximum failed nodes in the current poset
    def activate_max_passed(poset = nil)
      ## default to current poset
      poset ||= self.current_poset

      ## fetch the passed bubble statuses in that poset
      passed = self.bubble_statuses.where(bubble: poset.bubbles).where(passed: true)

      ## activate nodes where all successors in that poset are failed
      passed.each do |passed_status|
        unless passed_status.successors(poset).exists? passed: true
          passed_status.active = true
          passed_status.save
        end
      end
    end

    ## clean up when switching from backward to full
    def clean_bubbles_backward
      ## default to full poset
      poset = self.bubble_group.full_poset

      ## check all active passed in the full poset
      passed = self.bubble_statuses.where(bubble: poset.bubbles).where(passed: true, active: true)

      ## deactivate if ALL SUCCESSORS are passed
      passed.each do |passed_status|
        unless passed_status.successors(poset).exists? passed: false
          passed_status.active = false
          passed_status.save
        end
      end
    end

    ## clean up when switching from forward to full
    def clean_bubbles_forward
      ## default to full poset
      poset = self.bubble_group.full_poset

      ## check all active failed in the full poset
      failed = self.bubble_statuses.where(bubble: poset.bubbles).where(passed: false, active: true)

      ## deactivate unless ALL PREDECESSORS are passed
      failed.each do |failed_status|
        if failed_status.predecessors(poset).exists? passed: false
          failed_status.active = false
          failed_status.save
        end
      end
    end
end
