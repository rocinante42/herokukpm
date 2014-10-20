class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.integer :source_id
      t.integer :destination_id
      t.integer :poset_id

      t.timestamps
    end
  end
end
