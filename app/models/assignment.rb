class Assignment < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  belongs_to :classroom
  belongs_to :general, class_name: 'Assignment', foreign_key: 'general_id'
  has_many :sub_assignments, class_name: 'Assignment', foreign_key: 'general_id'
  has_many :kid_activities

  scope :general, -> {where(kid:nil)}

  STATUSES = [
    NONE = 0,
    INACTIVE = 1,
    ACTIVE = 2,
    PASSED = 3
  ]

  after_save :track_activity
  after_create :create_sub_assignments, if: Proc.new{ |assignment| assignment.general? }
  after_update :update_all_assignments_statuses, if: Proc.new{ |assignment| assignment.general? }

  def none?
  	status == NONE
  end

  def inactive?
  	status == INACTIVE
  end

  def active?
  	status == ACTIVE
  end

  def track_activity
    assignments = general? ? sub_assignments : [self]
    assignments.each(&:single_track_activity)
  end

  def single_track_activity
    kid_activities.last.touch if inactive? && kid_activities.any?
    kid_activities.create if active?
  end

  def time_left_in_seconds
    assignments = general? ? sub_assignments : [self]
    assignments.map(&:single_time_left_in_seconds).inject(:+)
  end

  def single_time_left_in_seconds
    last_activity_progress = active? ? Time.now - kid_activities.last.created_at : 0
    (time_limit - kid_activities.map(&:total_time).inject(:+) - last_activity_progress)
  end

  def expired?
    time_left_in_seconds <= 0
  end

  def general?
    kid.nil?
  end

  def create_sub_assignments
    classroom.kids.each do |kid|
      assignment = Assignment.where(bubble_group: bubble_group, kid:kid).first_or_initialize
      if assignment.new_record?
        assignment.status = ACTIVE
        assignment.time_limit = time_limit
        assignment.general = self
        assignment.save!
      end
    end
  end

  def update_all_assignments_statuses
    sub_assignments.update_all(status:status)
  end
end
