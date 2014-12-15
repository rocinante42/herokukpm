class CreateBubbles < ActiveRecord::Migration
  def change
    create_table :bubbles do |t|
      t.string :name
      t.string :description
      t.integer :bubble_group_id

      t.timestamps
    end
  end
end
