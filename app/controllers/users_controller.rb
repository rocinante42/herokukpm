class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_available_classrooms, only: [:activities, :dashboard_classroom]
  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    @page = params[:page] || 1
    @users = User.all.where.not(id: current_user).paginate(page: @page, per_page: 10)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_role(name: 'Teacher')
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_admin_path(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        @user.build_role(name: 'Teacher')
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_admin_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_admin_index_path, notice: 'User was successfully destroyed.' }
      format.js
      format.json { head :no_content }
    end
  end

  def activities
    @total_assignments_hash = {}
    BubbleGroup.all.find_each do |bg|
      next unless @current_classroom_type.bubble_groups.include? bg
      assignment = @current_classroom.assignments.general.where(bubble_group: bg, status: [Assignment::ACTIVE, Assignment::INACTIVE]).first_or_initialize
      assignment.status = Assignment::NONE if assignment.new_record?
      @total_assignments_hash[bg.id] = {}
      @total_assignments_hash[bg.id][:bubble_group] = bg
      @total_assignments_hash[bg.id][:global_assignment] = assignment
      @current_classroom.kids.each do |kid|
        assignment = kid.assignments.where(bubble_group: bg, status: [Assignment::ACTIVE, Assignment::INACTIVE]).first_or_initialize
        assignment.status = Assignment::NONE if assignment.new_record?
        @total_assignments_hash[bg.id][:kid_assignments] ||= {}
        @total_assignments_hash[bg.id][:kid_assignments][kid.id] = assignment
      end
    end

    @time_options = [['2 Hours', 2.hours], ['1 Day', 1.days], ['2 Days', 2.days], ['5 Days', 5.days]]
  end

  def dashboard_classroom
  end

  def dashboard
    @classroom_types = ClassroomType.all
    if current_user.admin?
      @current_school = School.all.sample
    elsif current_user.teacher?
      @current_school = current_school
    else
      @current_school = current_user.school
    end
    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
      @current_school = @current_classroom.school
    else
      @current_classroom = @current_school.classrooms.sample
    end
    if params.has_key? :school
      @current_school = School.find(params[:school])
      @current_classroom = @current_school.classrooms.sample
    end

    @time_intervals_and_kids = []
    kids = @current_classroom.kids.includes(:kid_activities)
    if KidActivity.joins(:assignment).where(assignments:{kid_id: kids.pluck(:id)}).any?
      kids_time = kids.map(&:recent_play_time)
      max_time = kids_time.max{|a,b| a <=> b }
      step = max_time / 5
      steps = (0..max_time).step(step).to_a
      time_intervals_in_seconds = steps.map.with_index{|el, index| [el, steps[index+1]]}[0...-1]
      time_intervals_in_minutes = time_intervals_in_seconds.map{|step| [(step[0]/60).round, (step[1]/60).round]}
      time_intervals_in_minutes.each_with_index do |ti, index|
        selected_kids = kids.select{|kid| (ti[0]..ti[1]).include? (kid.recent_play_time/60).round}
        @time_intervals_and_kids[index] = {}
        @time_intervals_and_kids[index][:time_interval] = ti
        @time_intervals_and_kids[index][:kids] = selected_kids
      end
      @kids_count_per_timegroup = @time_intervals_and_kids.map{|item| item[:kids].count}
    else
      @kids_count_per_timegroup = Array.new(5,0)
      @time_intervals_and_kids = Array.new(5,{})
      @time_intervals_and_kids.each_with_index do |item, index|
        item[:time_interval] = [24 * index ,24 * (index + 1)]
        item[:kids] = []
      end
    end

    if params.has_key? :current_cr
      @bottom_current_classroom = Classroom.find(params[:current_cr])
      @bottom_current_classroom_type = @bottom_current_classroom.classroom_type
    else
      @bottom_current_classroom_type = @current_classroom.classroom_type
      @bottom_current_classroom = @current_classroom
    end
    @total_hash = {}
    @current_school.classrooms.group_by(&:classroom_type_id).each do |ct_id, classrooms|
      ct = ClassroomType.find(ct_id)
      ct_name = ct.type_name
      @total_hash[ct_name] = {
        classrooms: {}
      }
      classrooms.each do |cr|
        @total_hash[ct_name][:classrooms][cr.id] = {}
        @total_hash[ct_name][:classrooms][cr.id][:classroom] = cr
        @total_hash[ct_name][:classrooms][cr.id][:bubble_groups] = {}
        ct.bubble_groups.each do |bg|
          @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name] = {}
          @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name][:categories] = {}
          bg.bubble_categories.sort_by{|ct| ct.name.split('-').first.to_i}.each do |category|
            total_count = category.bubbles.count * cr.kids.count
            passed_count = category.bubbles.joins(bubble_statuses: :bubble_group_status).where(bubble_statuses:{passed:true}, bubble_group_statuses:{kid_id:cr.kids.pluck(:id)}).count.to_f
            @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name][:categories][category.name] = {
              passed: passed_count / total_count * 100
            }
          end
        end
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def teacher_mode
  end

  def dashboard_admin
    @menu_options = {
                      'Person Management'=>
                      {
                        'View Kids' => kids_path,
                        'View Classrooms' => classrooms_path,
                        'View Schools' => schools_path,
                        'View Users' => users_admin_index_path
                      },
                      'Game Management' =>
                      {
                        'View Bubble Groups' => bubble_groups_path,
                        'View Bubble Group Statuses' => bubble_group_statuses_path,
                        'View Posets' => posets_path,
                        'View Games' => games_path,
                        'View Bubbles' => bubbles_path,
                        'View Bubble Games' => bubble_games_path,
                        'View Bubble Categories' => bubble_categories_path,
                        'View Triggers' => triggers_path
                      }
                    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :direct_phone, :role_id)
    end

    def set_available_classrooms
      @teachers = User.teachers.to_a
      @teachers.unshift(OpenStruct.new(id: nil, full_name: 'Choose Teacher'))
      @school_hash = {}
      School.all.find_each do |school|
        @school_hash[school.id] = {
          name: school.name,
          classrooms: {}
        }
        school.classrooms.to_a.group_by(&:classroom_type_id).each do |ct, classrooms|
          classroom_type = ClassroomType.find(ct)
          @school_hash[school.id][:classrooms][classroom_type.id] = classrooms.map{|cr| [cr.id, cr.name, cr.user_id]}
        end
      end
      if current_user.admin?
        classrooms = Classroom.all
        @classroom_types = ClassroomType.all
      else
        if current_user.teacher?
          classrooms = Classroom.where(school: current_school, teacher: current_user)
          @teachers = User.where(id: current_user.id)
        else
          classrooms = Classroom.where(school: current_user.school)
        end
        @classroom_types = ClassroomType.joins(:classrooms).merge(classrooms).uniq
      end
      if params.has_key? :classroom
        @current_classroom = Classroom.find(params[:classroom])
      else
        @current_classroom = classrooms.sample
      end
      @current_school = @current_classroom.school
      if params.has_key? :school
        @current_school = School.find(params[:school])
        @current_classroom = @current_school.classrooms.sample
      end
      @current_classroom_type = @current_classroom.classroom_type

      @classroom_hash = {}
      @school_hash[@current_school.id][:classrooms].each do |ct_id, classrooms|
        current_classrooms = classrooms
        if current_user.teacher?
          current_classrooms = current_classrooms.select{|cr| cr[2] == current_user.id}
        end
        @classroom_hash[ct_id] = current_classrooms
      end
    end
end
