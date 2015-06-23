class PromoteBubbleGroupStatusActiveToInteger < ActiveRecord::Migration
  def change
    remove_column :bubble_group_statuses, :active, :boolean
    add_column :bubble_group_statuses, :active, :integer, default: BubbleGroupStatus::ACTIVE_NONE
  end
end
