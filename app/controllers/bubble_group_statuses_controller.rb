class BubbleGroupStatusesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /bubble_group_statuses
  # GET /bubble_group_statuses.json
  def index
    @bubble_group_statuses = BubbleGroupStatus.all
  end

  # GET /bubble_group_statuses/1
  # GET /bubble_group_statuses/1.json
  def show
  end

  # GET /bubble_group_statuses/new
  def new
    @bubble_group_status = BubbleGroupStatus.new
  end

  # GET /bubble_group_statuses/1/edit
  def edit
  end

  # POST /bubble_group_statuses
  # POST /bubble_group_statuses.json
  def create
    @bubble_group_status = BubbleGroupStatus.new(bubble_group_status_params)

    respond_to do |format|
      if @bubble_group_status.save
        format.html { redirect_to @bubble_group_status, notice: 'Bubble group status was successfully created.' }
        format.json { render :show, status: :created, location: @bubble_group_status }
      else
        format.html { render :new }
        format.json { render json: @bubble_group_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bubble_group_statuses/1
  # PATCH/PUT /bubble_group_statuses/1.json
  def update
    respond_to do |format|
      if @bubble_group_status.update(bubble_group_status_params)
        format.html { redirect_to @bubble_group_status, notice: 'Bubble group status was successfully updated.' }
        format.json { render :show, status: :ok, location: @bubble_group_status }
      else
        format.html { render :edit }
        format.json { render json: @bubble_group_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bubble_group_statuses/1
  # DELETE /bubble_group_statuses/1.json
  def destroy
    @bubble_group_status.destroy
    respond_to do |format|
      format.html { redirect_to bubble_group_statuses_url, notice: 'Bubble group status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ## POST /bubble_group_statuses/1/reset
  def reset
    @bubble_group_status.reset!
    render action: :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bubble_group_status
      @bubble_group_status = BubbleGroupStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bubble_group_status_params
      params.require(:bubble_group_status).permit(:kid_id, :bubble_group_id, :poset_id, :pass_counter, :fail_counter, :active)
    end
end
