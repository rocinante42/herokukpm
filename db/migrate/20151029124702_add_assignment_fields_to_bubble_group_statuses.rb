class AddAssignmentFieldsToBubbleGroupStatuses < ActiveRecord::Migration
  def change
  	add_column :bubble_group_statuses, :general_id, :integer
    add_reference :bubble_group_statuses, :classroom, index: true
    add_column :bubble_group_statuses, :time_limit, :integer
    add_column :kid_activities, :bubble_group_status_id, :integer
    remove_column :kid_activities, :assignment_id
  end
end
