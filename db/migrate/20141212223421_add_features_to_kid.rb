class AddFeaturesToKid < ActiveRecord::Migration
  def change
    add_column :kids, :age, :integer
    add_column :kids, :first_name, :string
    add_column :kids, :last_name, :string
    add_column :kids, :gender, :integer
    add_column :kids, :primary_language, :string
  end
end
