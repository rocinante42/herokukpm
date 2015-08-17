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

  after_save :track_activity, if: Proc.new { |assignment| assignment.status == ACTIVE }

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
  	kid_activities.create
  end

  def time_left
  	(time_limit - (kid_activities.sum(:updated_at) - kid_activities.sum(:created_at))).seconds.from_now
  end
end
