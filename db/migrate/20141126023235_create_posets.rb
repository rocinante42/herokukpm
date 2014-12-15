class CreatePosets < ActiveRecord::Migration
  def change
    create_table :posets do |t|

      t.timestamps
    end
  end
end
