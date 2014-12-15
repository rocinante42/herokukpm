class CreateBubbleGroups < ActiveRecord::Migration
  def change
    create_table :bubble_groups do |t|
      t.string :name
      t.string :description
      t.integer :full_poset_id
      t.integer :forward_poset_id
      t.integer :backward_poset_id

      t.timestamps
    end
  end
end
