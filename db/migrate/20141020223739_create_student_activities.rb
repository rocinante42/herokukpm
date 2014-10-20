class CreateStudentActivities < ActiveRecord::Migration
  def change
    create_table :student_activities do |t|
      t.integer :status
      t.integer :score
      t.boolean :active
      t.belongs_to :poset, index: true
      t.belongs_to :activity, index: true
      t.belongs_to :game, index: true
      t.belongs_to :student, index: true

      t.timestamps
    end
  end
end
