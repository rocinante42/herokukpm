class BubbleGame < ActiveRecord::Base
  belongs_to :bubble
  belongs_to :game
end
