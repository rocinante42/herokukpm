class Student < ActiveRecord::Base
  belongs_to :classroom
  has_many :student_activities
end
