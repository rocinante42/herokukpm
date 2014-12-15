class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.integer :source_id
      t.integer :destination_id

      t.timestamps
    end
  end
end
