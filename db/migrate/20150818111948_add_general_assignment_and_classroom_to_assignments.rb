class AddGeneralAssignmentAndClassroomToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :general_id, :integer
    add_reference :assignments, :classroom, index: true
  end
end
