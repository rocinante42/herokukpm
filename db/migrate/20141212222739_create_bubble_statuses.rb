class CreateBubbleStatuses < ActiveRecord::Migration
  def change
    create_table :bubble_statuses do |t|
      t.integer :bubble_group_status_id
      t.integer :bubble_id
      t.boolean :passed
      t.boolean :active

      t.timestamps
    end
  end
end
