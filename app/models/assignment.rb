class Assignment < ActiveRecord::Base
  belongs_to :kid
  belongs_to :bubble_group
  has_many :kid_activities

  STATUSES = [
    NONE = 0,
    INACTIVE = 1,
    ACTIVE = 2,
    PASSED = 3
  ]

  after_save :track_activity

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
    kid_activities.last.touch if inactive? && kid_activities.any?
    kid_activities.create if active?
  end

  def time_left_in_seconds
    last_activity_progress = active? ? Time.now - kid_activities.last.created_at : 0
    (time_limit - kid_activities.map(&:total_time).inject(:+) - last_activity_progress)
  end
end
