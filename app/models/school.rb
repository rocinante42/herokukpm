class School < ActiveRecord::Base
  has_many :classrooms, dependent: :destroy
  has_many :students, through: :classrooms, source: :kids
  has_many :teacher_admins, class_name: 'User'
  has_many :teachers, through: :classrooms

  validates_presence_of :name
  validates_uniqueness_of :name
end
