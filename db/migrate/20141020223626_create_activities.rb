class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.integer :level
      t.integer :enjoy_score
      t.integer :complete_score
      t.integer :pass_counter
      t.integer :fail_counter
      t.integer :weight
      t.integer :max_level

      t.timestamps
    end
  end
end
