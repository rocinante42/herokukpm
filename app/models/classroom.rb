class Classroom < ActiveRecord::Base
  belongs_to :school
  belongs_to :classroom_type
  belongs_to :user
  validates_presence_of :school

  has_many :kids, dependent: :destroy

  def teacher
    return user
  end
  def class_type
    return classroom_type
  end


end
