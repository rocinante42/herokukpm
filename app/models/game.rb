class Game < ActiveRecord::Base
  validates :name, uniqueness: true
end
