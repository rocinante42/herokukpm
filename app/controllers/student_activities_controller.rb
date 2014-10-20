class StudentActivitiesController < ApplicationController
  before_action :set_student_activity, only: [:show, :edit, :update, :destroy]

  # GET /student_activities
  # GET /student_activities.json
  def index
    @student_activities = StudentActivity.all
  end

  # GET /student_activities/1
  # GET /student_activities/1.json
  def show
  end

  # GET /student_activities/new
  def new
    @student_activity = StudentActivity.new
  end

  # GET /student_activities/1/edit
  def edit
  end

  # POST /student_activities
  # POST /student_activities.json
  def create
    @student_activity = StudentActivity.new(student_activity_params)

    respond_to do |format|
      if @student_activity.save
        format.html { redirect_to @student_activity, notice: 'Student activity was successfully created.' }
        format.json { render :show, status: :created, location: @student_activity }
      else
        format.html { render :new }
        format.json { render json: @student_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_activities/1
  # PATCH/PUT /student_activities/1.json
  def update
    respond_to do |format|
      if @student_activity.update(student_activity_params)
        format.html { redirect_to @student_activity, notice: 'Student activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_activity }
      else
        format.html { render :edit }
        format.json { render json: @student_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_activities/1
  # DELETE /student_activities/1.json
  def destroy
    @student_activity.destroy
    respond_to do |format|
      format.html { redirect_to student_activities_url, notice: 'Student activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_activity
      @student_activity = StudentActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_activity_params
      params.require(:student_activity).permit(:status, :score, :active, :poset_id, :activity_id, :game_id)
    end
end
