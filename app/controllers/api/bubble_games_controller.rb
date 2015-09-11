class Api::BubbleGamesController < Api::ApiController
  before_action :authenticate

  def index
    @bubble_games = BubbleGame.all
  end

  def show
    @bubble_game = BubbleGame.find(params[:id])
  end
end
