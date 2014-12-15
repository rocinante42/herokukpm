class BubbleGroupsController < ApplicationController
  before_action :set_bubble_group, only: [:show, :edit, :update, :destroy]

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

      if bubble_file
        bubbles = Bubble.create_from_csv bubble_file, {bubble_group: @bubble_group}
      end

      name = params[:bubble_group][:name]
      full_poset = Poset.create_from_csv(full_poset_file, {name: "#{name} -- Full Poset"})
      forward_poset = Poset.create_from_csv(forward_poset_file, {name: "#{name} -- Forward Poset"})
      backward_poset = Poset.create_from_csv(backward_poset_file, {name: "#{name} -- Backward Poset"})

      @bubble_group.full_poset = full_poset if full_poset
      @bubble_group.forward_poset = forward_poset if forward_poset
      @bubble_group.backward_poset = backward_poset if backward_poset

      @bubble_group.save
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
      params.require(:bubble_group).permit(:name, :description, :full_poset_id, :forward_poset_id, :backward_poset_id)
    end
end
