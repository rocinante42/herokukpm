class Api::KidsController < Api::ApiController

  def show
    @kid = Kid.find(params[:id])
  end
  
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

  ## GET api/kids/1/games
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

  ## POST api/kids/1/result
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

    render json: {success: success}
  end
end
