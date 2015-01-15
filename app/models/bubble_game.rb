class BubbleGame < ActiveRecord::Base
  require 'csv'
  belongs_to :bubble
  belongs_to :game

  validates :bubble, :game, presence: true

  def self.create_from_csv csv_file, bubble_group = nil, bubble_game_params = {}
    bubble_games = []

    ## restrict the bubbles and games
    bubble_collection = bubble_group.try(:bubbles) || Bubble.all
    game_collection = Game.all

    if csv_file
      CSV.foreach(csv_file.path, {headers:true}) do |row|
        ## extract column info
        bubble_name = row[0]
        game_name = row[1]

        ## fetch the bubble and game
        bubble = bubble_collection.where(name: bubble_name).first
        game = game_collection.where(name: game_name).first

        ## create entry for valid bubbles and games or log errors
        if bubble && game
          bg = BubbleGame.find_or_initialize_by(bubble: bubble, game: game)
          bg.update(bubble_game_params)
          if !bg.save
            ## TODO :: potentially handle creation errors here
          else
            bubble_games << bg
          end
        else
          logger.debug "BubbleGame.create_from_csv :: failed to find bubble '#{bubble_name}'"if bubble.nil?
          logger.debug "BubbleGame.create_from_csv :: failed to find game '#{game_name}'"if game.nil?
        end
      end
    end

    ## return new collection of games
    return bubble_games
  end
end
