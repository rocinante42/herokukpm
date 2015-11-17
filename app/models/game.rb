class Game < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :name, length: { maximum:50 }
  validates :description, length: { maximum: 255 }
  has_many :bubble_games, dependent: :destroy
  has_many :bubbles, through: :bubble_games
end
