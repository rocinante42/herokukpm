class TriggersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trigger, only: [:create, :update]
  load_and_authorize_resource

  # GET /triggers
  # GET /triggers.json
  def index
    @triggers = Trigger.all
  end

  # GET /triggers/1
  # GET /triggers/1.json
  def show
  end

  # GET /triggers/new
  def new
    @trigger = Trigger.new(bubble_group: BubbleGroup.new, bubble: Bubble.new)
  end

  # GET /triggers/1/edit
  def edit
  end

  # POST /triggers
  # POST /triggers.json
  def create
    if params[:trigger].has_key? :trigger_csv_file
      Trigger.create_from_csv params[:trigger][:trigger_csv_file]
      redirect_to triggers_url
    else
      respond_to do |format|
        if @new_trigger.save
          format.html { redirect_to @trigger, notice: 'Trigger was successfully created.' }
          format.json { render :show, status: :created, location: @trigger }
        else
          format.html { render :new }
          format.json { render json: @trigger.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /triggers/1
  # PATCH/PUT /triggers/1.json
  def update
    @trigger.assign_attributes(@new_trigger.attributes.slice('bubble_group_id', 'bubble_id'))
    respond_to do |format|
      if @trigger.save
        format.html { redirect_to @trigger, notice: 'Trigger was successfully updated.' }
        format.json { render :show, status: :ok, location: @trigger }
      else
        format.html { render :edit }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.json
  def destroy
    @trigger.destroy
    respond_to do |format|
      format.html { redirect_to triggers_url, notice: 'Trigger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_bubbles
    @bubble_group = BubbleGroup.find(params[:bubble_group_id])
    @bubbles = @bubble_group.bubbles.to_a
    @bubbles.unshift(OpenStruct.new(id:nil, name:nil))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trigger
      @trigger = Trigger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trigger_params
      params.require(:trigger).permit(:bubble_id, :bubble_group_id, :destination_id)
    end

    def set_trigger
      source = BubbleGroup.find_by(id: trigger_params[:bubble_group_id].to_i).try(:name)
      bubble = Bubble.find_by(id: trigger_params[:bubble_id].to_i).try(:name)
      destination = BubbleGroup.find_by(id: trigger_params[:destination_id].to_i).try(:name)
      @new_trigger = Trigger.initialize_with_data [source, bubble, destination]
    end
end
