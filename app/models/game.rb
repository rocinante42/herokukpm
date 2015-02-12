class Game < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :bubble_games, dependent: :destroy
  has_many :bubbles, through: :bubble_games
end
