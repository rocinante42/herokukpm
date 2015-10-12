class ClassroomType < ActiveRecord::Base
 has_many :classrooms
 has_and_belongs_to_many :bubble_groups, ->{ order id: :asc }, join_table: 'bubble_groups_classroom_types'
end
