class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :location
      t.string :primary_language
      t.string :game_language
      t.boolean :first_time
      t.belongs_to :classroom, index: true

      t.timestamps
    end
  end
end
