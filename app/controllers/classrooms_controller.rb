class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /classrooms
  # GET /classrooms.json
  def index
    if current_user.teacher?
      classrooms = Classroom.where(school: current_school, user: current_user)
    else
      classrooms = Classroom.all
    end
    @classroom_types = ClassroomType.all

    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
      @current_classroom_type = @current_classroom.classroom_type
    else
      @current_classroom = classrooms.sample
      @current_classroom_type = @current_classroom.classroom_type
    end

    @classroom_hash = {}
    @classroom_types.each do |ct|
      current_classrooms = current_user.teacher? ? ct.classrooms.where(school: current_school, user: current_user) : ct.classrooms
      @classroom_hash[ct.id] = current_classrooms.pluck(:id, :name) 
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
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms
  # POST /classrooms.json
  def create
    @classroom = Classroom.new(classroom_params)

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
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html { redirect_to @classroom, notice: 'Classroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit }
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
      params.require(:classroom).permit(:name, :school_id, :classroom_type_id,:user_id)
    end
end
