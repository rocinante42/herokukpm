class CreateJoinTableBubbleCategoriesClassroomTypes < ActiveRecord::Migration
  def change
    create_join_table :bubble_categories, :classroom_types do |t|
      # t.index [:bubble_category_id, :classroom_type_id]
      # t.index [:classroom_type_id, :bubble_category_id]
    end
  end
end
