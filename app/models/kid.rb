class Kid < ActiveRecord::Base
  belongs_to :classroom

  has_many :bubble_group_statuses, dependent: :destroy
  has_many :bubble_statuses, through: :bubble_group_statuses

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def kindergarten?
    classroom.kindergarten?
  end

  def first_grade?
    classroom.first_grade?
  end

  def male?
    gender == 1
  end

  def female?
    gender == 2
  end
end
