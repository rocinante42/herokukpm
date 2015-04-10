class CreateBubbleCategories < ActiveRecord::Migration
  def change
    create_table :bubble_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
