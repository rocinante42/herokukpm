class Api::GamesController < Api::ApiController
  before_action :authenticate

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end
end
