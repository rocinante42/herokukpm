class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :kid, index: true
      t.references :bubble_group, index: true
      t.integer :status, default: 0
      t.integer :time_limit

      t.timestamps
    end
  end
end
