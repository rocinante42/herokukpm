class CreateBubbleGroupsClassroomTypes < ActiveRecord::Migration
  def change
    create_table :bubble_groups_classroom_types, id: false do |t|
      t.belongs_to :bubble_group, index: true
      t.belongs_to :classroom_type, index: true
    end
  end
end
