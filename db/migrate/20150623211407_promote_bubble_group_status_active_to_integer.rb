class PromoteBubbleGroupStatusActiveToInteger < ActiveRecord::Migration
  def up
    change_column :bubble_group_statuses, :active, :integer, default: BubbleGroupStatus::ACTIVE_NONE
  end

  def down
    change_column :bubble_group_statuses, :active, :boolean
  end
end
