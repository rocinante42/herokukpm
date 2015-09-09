class AddAccessTokenToKids < ActiveRecord::Migration
  def change
    add_column :kids, :access_token, :string
  end
end
