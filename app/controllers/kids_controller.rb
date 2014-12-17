class KidsController < ApplicationController
  before_action :set_kid, only: [:show, :edit, :update, :destroy, :play]

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
      format.html { redirect_to kids_url, notice: 'Kid was successfully destroyed.' }
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
        @bubble_group_status.reset!
      end

      ## handle the result, if present
      if params.has_key?(:result) && params.has_key?(:bubble_status_id)
        bubble_status = BubbleStatus.find(params[:bubble_status_id])
        case params[:result]
        when 'pass'
          @bubble_group_status.pass! bubble_status
        when 'fail'
          @bubble_group_status.fail! bubble_status
        when 'enjoy'
          @bubble_group_status.enjoy! bubble_status
        end
      end

      ## return a randomly sampled active bubble
      @available_bubbles = @bubble_group_status.available_bubbles
      @bubble_status = @available_bubbles.sample
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
