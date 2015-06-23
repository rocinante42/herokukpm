class PromoteBubbleGroupStatusActiveToInteger < ActiveRecord::Migration
  def up
    change_column :bubble_group_statuses, :active, :integer, using: 'integer USING CAST(active as integer)', default: BubbleGroupStatus::ACTIVE_NONE
  end

  def down
    change_column :bubble_group_statuses, :active, :boolean, using: 'boolean USING CAST(active as boolean)'
  end
end
