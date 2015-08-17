class CreateKidActivities < ActiveRecord::Migration
  def change
    create_table :kid_activities do |t|
      t.references :assignment, index: true

      t.timestamps
    end
  end
end
