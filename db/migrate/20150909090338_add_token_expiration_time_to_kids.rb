class AddTokenExpirationTimeToKids < ActiveRecord::Migration
  def change
    add_column :kids, :token_expiration_time, :datetime
  end
end
