class CreateClassroomTypes < ActiveRecord::Migration
  def change
    create_table :classroom_types do |t|
      t.string :type_name
      t.string :type_description

      t.timestamps
    end
  end
end
