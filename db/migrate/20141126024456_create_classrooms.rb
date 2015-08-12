class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :name
      t.belongs_to :classroom_type, index: true
      t.belongs_to :user, index: true
      t.integer :school_id

      t.timestamps
    end
  end
end
