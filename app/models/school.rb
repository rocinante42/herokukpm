class School < ActiveRecord::Base
  has_many :classrooms, dependent: :destroy
  has_many :students, through: :classrooms, source: :students
  has_many :teacher_admins, class_name: 'User'
  has_many :teachers, through: :classrooms

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :name, length: { maximum: 50 }, format: { with: /\A([a-zA-Z]+)(.*)\z/ }
end
