class BubbleGroupStatus < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  belongs_to :poset

  has_many :bubble_statuses, dependent: :destroy

  alias :current_poset :poset

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

  ## sets up the statuses on all bubbles for the bubble group
  def reset!
    ## this should all be done in a single transaction, since we should do everything or nothing
    ActiveRecord::Base.transaction do
      ## reset the counters and the poset
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

    ## activate all required nodes in the current poset
    activation_check(bubble_status)

    ## pass all of the nodes in the downset in the full poset
    bubble_status.downset(self.bubble_group.full_poset).update_all(passed: true, active: false)
    bubble_status.reload

    ## switch poset, if necessary and possible
    if self.pass_counter >= self.current_poset.pass_threshold
      next_poset = self.next_poset
      unless self.current_poset == next_poset
        ## reset the pass counter and move to the next poset
        self.pass_counter = 0
        self.poset = next_poset

        ## activate minimum failed in the new poset
        activate_min_failed
      end
    end
  end

  def fail bubble_status
    ## adjusts the counters
    self.pass_counter = 0
    self.fail_counter += 1

    ## fail and deactivate everything in the upset
    bubble_status.upset(self.bubble_group.full_poset).update_all(passed: false, active: false)
    bubble_status.reload

    ## if this bubble is a minimum, reactivate it
    if bubble_status.predecessors.count == 0
      bubble_status.active = true
      bubble_status.save!
    else
      bubble_status.predecessors.each do |predecessor|
        predecessor.active = true
        predecessor.save!
      end
    end

    ## switch poset, if necessary
    if self.fail_counter >= self.current_poset.fail_threshold
      prev_poset = self.previous_poset
      unless self.poset == prev_poset
        self.fail_counter = 0
        self.poset = prev_poset

        ## switch to backward poset
        activate_max_passed
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

  private
    def activation_check(bubble_status)
      ## get active bubbles in the downset
      statuses = bubble_status.downset(self.current_poset).active

      ## deactivate and check successors for each of those
      statuses.each do |status|
        status.active = false
        status.save!

        status.successors.each do |successor_status|
          unless successor_status.predecessors.exists?( passed: false )
            successor_status.active = true
            successor_status.save!
          end
        end
      end
    end

    ## activate the minimum failed nodes in the current poset
    def activate_min_failed(poset = nil)
      ## default to the current poset
      poset ||= self.current_poset

      ## fetch the failed bubble statuses in that poset
      failed = self.bubble_statuses.where(bubble: poset.bubbles).where(passed: false)

      ## activate nodes where all predecessors in that poset are passed
      failed.each do |failed_status|
        unless failed_status.predecessors(poset).exists? passed: false
          failed_status.active = true
          failed_status.save
        end
      end
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
end

