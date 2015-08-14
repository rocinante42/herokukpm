class KidsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token, :only => [:result]

  # GET /kids
  # GET /kids.json
  def index
    @kids = Kid.all
  end

  # GET /kids/1
  # GET /kids/1.json
  def show
  end

  # GET /kids/new
  def new
    @kid = Kid.new
  end

  # GET /kids/1/edit
  def edit
  end

  ## GET /kids/1/report
  def reports
    @reports = {}
    BubbleCategory.all.each do |category|
      ## fetch the statuses for this category
      statuses = @kid.bubble_statuses.joins(:bubble).where(bubbles: {bubble_category_id: category.id})

      ## store stats for those statuses
      @reports[category] = {
        passed: statuses.passed.count,
        active: statuses.active.count,
        total: statuses.count
      }
    end
  end

  # POST /kids
  # POST /kids.json
  def create
    @kid = Kid.new(kid_params)

    respond_to do |format|
      if @kid.save
        format.html { redirect_to @kid, notice: 'Kid was successfully created.' }
        format.json { render :show, status: :created, location: @kid }
      else
        format.html { render :new }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kids/1
  # PATCH/PUT /kids/1.json
  def update
    respond_to do |format|
      if @kid.update(kid_params)
        format.html { redirect_to @kid, notice: 'Kid was successfully updated.' }
        format.json { render :show, status: :ok, location: @kid }
      else
        format.html { render :edit }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kids/1
  # DELETE /kids/1.json
  def destroy
    @kid.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ## GET /kids/1/play/
  def play
    if params.has_key? :bubble_group_id
      ## fetch the bubble group
      @bubble_group = BubbleGroup.find(params[:bubble_group_id])

      ## find or create the bubble group status
      @bubble_group_status = @kid.bubble_group_statuses.find_by(bubble_group: @bubble_group)
      unless @bubble_group_status
        @bubble_group_status = @kid.bubble_group_statuses.create(bubble_group: @bubble_group)
      end

      ## handle the result, if present
      if params.has_key?(:result) && params.has_key?(:bubble_status_id)
        ## get bubble status
        bubble_status = BubbleStatus.find(params[:bubble_status_id])
        @bubble_group_status.safe_handle_result! bubble_status, params[:result]
      end

      ## return a randomly sampled active bubble
      @available_bubbles = @bubble_group_status.available_bubbles
      @bubble_status = @available_bubbles.sample
    end
  end

  ## GET /kids/1/play_game/
  def play_game
    ## handle the result, if present
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      ## get the bubble status
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
    end

    ## if a game id was passed in, we want a bubble that supports that game
    if params[:game_id].present?
      @game = Game.find(params[:game_id])
    end

    ## build a bubble group status for each bubble group, if needed, and assemble all of the active bubbles
    available = []
    BubbleGroup.all.each do |bubble_group|
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble_group)
      if bubble_group_status.active?
        available += bubble_group_status.available_bubbles
      end
    end

    ## randomly select one of the bubble statuses
    if @game
      ## select a bubble status that supports the selected game
      @bubble_status = available.select{ |bs| bs.bubble.games.include? @game }.sample

      ## get the bubble, and the bubble_game
      if @bubble_status
        @bubble = @bubble_status.bubble
        @bubble_game = @bubble.bubble_games.find_by(game: @game)
      end
    else
      ## select any of the bubble statuses
      @bubble_status = available.select{|bs| bs.bubble.games.count > 0 }.sample

      if @bubble_status
        ## extract the games, sample a game, and get the bubble-game object
        @bubble = @bubble_status.bubble
        @game = @bubble.games.sample
        @bubble_game = @bubble.bubble_games.find_by(game: @game)
      end
    end
  end

  ## GET /kids/1/games
  def games
    ## handle the result, if present
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
    end

    ## build a bubble group status for each bubble group, if needed, and assemble all of the active bubbles
    available = []
    BubbleGroup.all.each do |bubble_group|
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble_group)
      if bubble_group_status.active?
        available += bubble_group_status.available_bubbles
      end
    end

    ## sort info
    @bubble_games = []
    @games_hash = {}
    available.each do |bubble_status|
      bubble_status.bubble.bubble_games.each do |bubble_game|
        arr = @games_hash[bubble_game.game] || []
        arr << bubble_game
        @bubble_games << bubble_game
        @games_hash[bubble_game.game] = arr
      end
    end

    ## filter the results on the game name itself
    if params.has_key? :game_names
      game_names = params[:game_names]
      game_names = [game_names] unless game_names.is_a? Array

      @bubble_games.delete_if{ |bg| !game_names.include? bg.game.name }
      @games_hash.delete_if{ |g, v| !game_names.include? g.name }
    end
  end

  ## POST /kids/1/result
  def result
    success = false
    if params.has_key?(:result) && params.has_key?(:bubble_id)
      ## ensure that the bubble group status exists
      bubble = Bubble.find(params[:bubble_id])
      bubble_group_status = @kid.bubble_group_statuses.find_or_create_by(bubble_group: bubble.bubble_group)

      ## update the bubble status as needed
      bubble_status = @kid.bubble_statuses.find_by(bubble_id: params[:bubble_id])
      bubble_status.bubble_group_status.safe_handle_result! bubble_status, params[:result]
      success = true
    end

    respond_to do |format|
      format.json { render json: {success: success} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kid
      @kid = Kid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kid_params
      params.require(:kid).permit(:login_id, :classroom_id, :school_id, :first_name, :last_name, :gender, :age, :primary_language)
    end
end
