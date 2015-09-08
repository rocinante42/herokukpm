class FamilyRelationship < ActiveRecord::Base
  belongs_to :parent, class_name: 'User', foreign_key: 'user_id'
  belongs_to :kid
  accepts_nested_attributes_for :parent
end
