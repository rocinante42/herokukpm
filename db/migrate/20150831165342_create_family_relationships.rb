class CreateFamilyRelationships < ActiveRecord::Migration
  def change
    create_table :family_relationships do |t|
      t.references :user, index: true
      t.references :kid, index: true

      t.timestamps
    end
  end
end
