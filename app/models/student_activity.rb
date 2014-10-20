class StudentActivity < ActiveRecord::Base
  belongs_to :poset
  belongs_to :activity
  belongs_to :game
  belongs_to :student
end
