class AddThresholdsToPosets < ActiveRecord::Migration
  def change
    add_column :posets, :fail_threshold, :integer, null: false, default: 2
    add_column :posets, :pass_threshold, :integer, null: false, default: 2
  end
end
