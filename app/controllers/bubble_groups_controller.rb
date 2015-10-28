class BubbleGroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  helper_method :set_data_from_params

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
    set_data_from_params(destroy_old_data: false)

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
    set_data_from_params(destroy_old_data: true)

    @bubble_group.save

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

    def set_data_from_params destroy_old_data:
      unless @bubble_group.errors.any?
        bubbles = Bubble.all
        bubble_file = params[:bubble_group][:bubble_file]

        if bubble_file
          @bubble_group.bubbles.destroy_all if destroy_old_data
          bubble_arr = Bubble.create_from_csv bubble_file, {bubble_group: @bubble_group}
          bubbles = Bubble.where(id: bubble_arr.collect{ |b| b.id })
        end

        name = params[:bubble_group][:name]
        ['full', 'forward', 'backward'].each do |type|
          poset_file = params[:bubble_group]["#{type}_poset_file"]
          if poset_file
            @bubble_group.send("#{type}_poset").destroy if destroy_old_data
            new_poset = Poset.create_from_csv(poset_file, bubbles, {name: "#{name} -- #{type.capitalize} Poset"})
            @bubble_group.send("#{type}_poset=", new_poset) if new_poset
          end
        end
        @bubble_group.save
      end
      unless @bubble_group.errors.any?

        bubble_category_file = params[:bubble_group][:bubble_category_file]
        if bubble_category_file
          puts "delete bubble_categories !!!!!"
          categories = BubbleCategory.joins(:bubbles).merge(@bubble_group.bubbles).uniq
          categories.destroy_all if destroy_old_data
          BubbleCategory.create_from_csv(bubble_category_file, bubble_group: @bubble_group)
        end
        bubble_game_file = params[:bubble_group][:bubble_game_file]
        if bubble_game_file
          games = BubbleGame.joins(:bubble).where(bubbles: {id: @bubble_group.bubbles.pluck(:id)}).uniq
          games.destroy_all if destroy_old_data
          BubbleGame.create_from_csv(bubble_game_file, @bubble_group, {})
        end
      end
    end
end
