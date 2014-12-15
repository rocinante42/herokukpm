class CreateBubbleGroupStatuses < ActiveRecord::Migration
  def change
    create_table :bubble_group_statuses do |t|
      t.integer :kid_id
      t.integer :bubble_group_id
      t.integer :poset_id
      t.integer :pass_counter, null: false, default: 0
      t.integer :fail_counter, null: false, default: 0

      t.timestamps
    end
  end
end
