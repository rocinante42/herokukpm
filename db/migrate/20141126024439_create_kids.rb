class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.integer :login_id
      t.integer :classroom_id

      t.timestamps
    end
  end
end
