class AddNameToPosets < ActiveRecord::Migration
  def change
    add_column :posets, :name, :string
  end
end
