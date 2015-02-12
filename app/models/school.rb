class School < ActiveRecord::Base
  has_many :classrooms, dependent: :destroy
end
