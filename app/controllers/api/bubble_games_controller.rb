class Api::BubbleGamesController < Api::ApiController

  def index
    @bubble_games = BubbleGame.all
  end

  def show
  	@bubble_game = BubbleGame.find(params[:id])
  end
end
