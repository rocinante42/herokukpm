class AddActiveToBubbleGroupStatus < ActiveRecord::Migration
  def change
    add_column :bubble_group_statuses, :active, :boolean, default: true
  end
end
