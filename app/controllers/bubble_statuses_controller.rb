class BubbleStatusesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /bubble_statuses
  # GET /bubble_statuses.json
  def index
    @bubble_statuses = BubbleStatus.all
  end

  # GET /bubble_statuses/1
  # GET /bubble_statuses/1.json
  def show
  end

  # GET /bubble_statuses/new
  def new
    @bubble_status = BubbleStatus.new
  end

  # GET /bubble_statuses/1/edit
  def edit
  end

  # POST /bubble_statuses
  # POST /bubble_statuses.json
  def create
    @bubble_status = BubbleStatus.new(bubble_status_params)

    respond_to do |format|
      if @bubble_status.save
        format.html { redirect_to @bubble_status, notice: 'Bubble status was successfully created.' }
        format.json { render :show, status: :created, location: @bubble_status }
      else
        format.html { render :new }
        format.json { render json: @bubble_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bubble_statuses/1
  # PATCH/PUT /bubble_statuses/1.json
  def update
    respond_to do |format|
      if @bubble_status.update(bubble_status_params)
        format.html { redirect_to @bubble_status, notice: 'Bubble status was successfully updated.' }
        format.json { render :show, status: :ok, location: @bubble_status }
      else
        format.html { render :edit }
        format.json { render json: @bubble_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bubble_statuses/1
  # DELETE /bubble_statuses/1.json
  def destroy
    @bubble_status.destroy
    respond_to do |format|
      format.html { redirect_to bubble_statuses_url, notice: 'Bubble status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bubble_status
      @bubble_status = BubbleStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bubble_status_params
      params.require(:bubble_status).permit(:kid_id, :bubble_id, :passed, :active)
    end
end
