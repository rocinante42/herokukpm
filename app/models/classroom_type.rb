class ClassroomType < ActiveRecord::Base
  has_many :classrooms
  has_and_belongs_to_many :bubble_groups
  has_and_belongs_to_many :bubble_categories
end
