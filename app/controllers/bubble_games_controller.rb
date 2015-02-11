class BubbleGamesController < ApplicationController
  before_action :set_bubble_game, only: [:show, :edit, :update, :destroy]

  # GET /bubble_games
  # GET /bubble_games.json
  def index
    @bubble_games = BubbleGame.all
  end

  # GET /bubble_games/1
  # GET /bubble_games/1.json
  def show
  end

  # GET /bubble_games/new
  def new
    @bubble_game = BubbleGame.new

    @bubble_game.bubble = Bubble.find(params[:bubble_id]) if params.has_key?(:bubble_id)
  end

  # GET /bubble_games/1/edit
  def edit
  end

  # POST /bubble_games
  # POST /bubble_games.json
  def create
    @bubble_game = BubbleGame.new(bubble_game_params)

    respond_to do |format|
      if @bubble_game.save
        format.html { redirect_to @bubble_game, notice: 'Bubble game was successfully created.' }
        format.json { render :show, status: :created, location: @bubble_game }
      else
        format.html { render :new }
        format.json { render json: @bubble_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bubble_games/1
  # PATCH/PUT /bubble_games/1.json
  def update
    respond_to do |format|
      if @bubble_game.update(bubble_game_params)
        format.html { redirect_to @bubble_game, notice: 'Bubble game was successfully updated.' }
        format.json { render :show, status: :ok, location: @bubble_game }
      else
        format.html { render :edit }
        format.json { render json: @bubble_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bubble_games/1
  # DELETE /bubble_games/1.json
  def destroy
    @bubble_game.destroy
    respond_to do |format|
      format.html { redirect_to bubble_games_url, notice: 'Bubble game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bubble_game
      @bubble_game = BubbleGame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bubble_game_params
      params.require(:bubble_game).permit(:bubble_id, :game_id, :skin, :game_params, :scoring_params)
    end
end
