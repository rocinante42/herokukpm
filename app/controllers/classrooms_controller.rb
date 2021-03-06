class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /classrooms
  # GET /classrooms.json
  def index
    if current_user.teacher?
      @current_school = current_user.school
      @classrooms = Classroom.where(school: @current_school, id: current_user.classroom)
      @schools = School.where(id: @current_school.id)
    else
      @schools = School.all
      @current_school = @schools.sample
      @classrooms = @current_school.classrooms
    end
    if params.has_key? :school
      @current_school = School.find(params[:school])
      @classrooms = @current_school.classrooms
    end
  end

  # GET /classrooms/1
  # GET /classrooms/1.json
  def show
    @bubble_groups = BubbleGroup.all
  end

  # GET /classrooms/new
  def new
    @classroom = Classroom.new
    @classroom.school = School.find(params[:school]) if params[:school]
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms
  # POST /classrooms.json
  def create
    @classroom = Classroom.new(classroom_params.except(:user_id))
    teacher = User.find_by(id: classroom_params[:user_id])
    @classroom.teachers << teacher if teacher
    respond_to do |format|
      if @classroom.save
        format.html { redirect_to @classroom, notice: 'Classroom was successfully created.' }
        format.json { render :show, status: :created, location: @classroom }
      else
        format.html { render :new }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classrooms/1
  # PATCH/PUT /classrooms/1.json
  def update
    @classroom.assign_attributes(classroom_params.except(:user_id))
    teacher = User.find_by(id: classroom_params[:user_id])
    @classroom.teachers << teacher if teacher
    respond_to do |format|
      if @classroom.save
        format.html { redirect_to params[:url] || @classroom, notice: 'Classroom was successfully updated.' }
        format.js{render nothing: true}
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit }
        format.js{render nothing: true}
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classrooms/1
  # DELETE /classrooms/1.json
  def destroy
    @classroom.destroy
    respond_to do |format|
      format.html { redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ## POST /classrooms/1/activate
  def activate
    ## update the active status of all mentioned bubble group statuses
    if params.has_key? :active
      params[:active].each do |k, v|
        status = BubbleGroupStatus.find(k)
        status.update(active: v.to_i)
      end
    end

    ## return to the show page
    redirect_to action: :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classroom_params
      params.require(:classroom).permit(:name, :school_id, :classroom_type_id, :user_id)
    end
end
