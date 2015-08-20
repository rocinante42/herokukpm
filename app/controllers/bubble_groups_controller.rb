class BubbleGroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /bubble_groups
  # GET /bubble_groups.json
  def index
    @bubble_groups = BubbleGroup.all
  end

  # GET /bubble_groups/1
  # GET /bubble_groups/1.json
  def show
  end

  # GET /bubble_groups/new
  def new
    @bubble_group = BubbleGroup.new
  end

  # GET /bubble_groups/1/edit
  def edit
  end

  # POST /bubble_groups
  # POST /bubble_groups.json
  def create
    @bubble_group = BubbleGroup.create(bubble_group_params)

    unless @bubble_group.errors.any?
      bubble_file = params[:bubble_group][:bubble_file]
      full_poset_file = params[:bubble_group][:full_poset_file]
      forward_poset_file = params[:bubble_group][:forward_poset_file]
      backward_poset_file = params[:bubble_group][:backward_poset_file]

      bubbles = Bubble.all
      if bubble_file
        bubble_arr = Bubble.create_from_csv bubble_file, {bubble_group: @bubble_group}
        bubbles = Bubble.where(id: bubble_arr.collect{ |b| b.id })
      end

      name = params[:bubble_group][:name]
      full_poset = Poset.create_from_csv(full_poset_file, bubbles, {name: "#{name} -- Full Poset"})
      forward_poset = Poset.create_from_csv(forward_poset_file, bubbles, {name: "#{name} -- Forward Poset"})
      backward_poset = Poset.create_from_csv(backward_poset_file, bubbles, {name: "#{name} -- Backward Poset"})

      @bubble_group.full_poset = full_poset if full_poset
      @bubble_group.forward_poset = forward_poset if forward_poset
      @bubble_group.backward_poset = backward_poset if backward_poset

      @bubble_group.save
    end

    ## create the bubble games, if possible
    unless @bubble_group.errors.any?
      bubble_game_file = params[:bubble_group][:bubble_game_file]
      bubble_games = BubbleGame.create_from_csv(bubble_game_file, @bubble_group, {})

      bubble_category_file = params[:bubble_group][:bubble_category_file]
      bubble_categories = BubbleCategory.create_from_csv(bubble_category_file, bubble_group: @bubble_group)
    end

    respond_to do |format|
      unless @bubble_group.errors.any?
        format.html { redirect_to @bubble_group, notice: 'Bubble group was successfully created.' }
        format.json { render :show, status: :created, location: @bubble_group }
      else
        format.html { render :new }
        format.json { render json: @bubble_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bubble_groups/1
  # PATCH/PUT /bubble_groups/1.json
  def update
    ## create the bubble games, if possible
    bubble_game_file = params[:bubble_group][:bubble_game_file]
    bubble_games = BubbleGame.create_from_csv(bubble_game_file, @bubble_group, {})

    bubble_category_file = params[:bubble_group][:bubble_category_file]
    bubble_categories = BubbleCategory.create_from_csv(bubble_category_file, bubble_group: @bubble_group)

    respond_to do |format|
      if @bubble_group.update(bubble_group_params)
        format.html { redirect_to @bubble_group, notice: 'Bubble group was successfully updated.' }
        format.json { render :show, status: :ok, location: @bubble_group }
      else
        format.html { render :edit }
        format.json { render json: @bubble_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bubble_groups/1
  # DELETE /bubble_groups/1.json
  def destroy
    @bubble_group.destroy
    respond_to do |format|
      format.html { redirect_to bubble_groups_url, notice: 'Bubble group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bubble_group
      @bubble_group = BubbleGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bubble_group_params
      params.require(:bubble_group).permit(:name, :description, :full_poset_id, :forward_poset_id, :backward_poset_id, classroom_type_ids:[])
    end
end
