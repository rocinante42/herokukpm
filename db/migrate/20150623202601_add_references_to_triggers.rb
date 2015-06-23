class AddReferencesToTriggers < ActiveRecord::Migration
  def change
    remove_column :triggers, :source_id, :integer
    remove_column :triggers, :destination_id, :integer

    add_reference :triggers, :bubble
    add_reference :triggers, :bubble_group
  end
end
