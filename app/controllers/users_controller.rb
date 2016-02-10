class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_available_classrooms, only: [:activities, :dashboard_classroom]
  before_action :set_available_data, only: [:new, :create, :edit, :update, :update_classrooms]
  helper_method :set_classrooms
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
    @user.role = Role.find_by(name: params[:role])
    @user.classroom = Classroom.find_by(id:params[:classroom])
    @user.school = current_user.school if current_user.teacher_admin?
    set_classrooms
  end

  # GET /users/1/edit
  def edit
    set_classrooms
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.classroom = Classroom.find_by(id:user_params[:classroom_id])
    respond_to do |format|
      if @user.save
        format.html { redirect_to params[:url] || dashboard_classroom_path(classroom: @user.classroom), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        set_classrooms
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.assign_attributes(user_params)
    @user.classroom = Classroom.find_by(id:user_params[:classroom_id])
    respond_to do |format|
      if @user.save
        format.html { redirect_to params[:url] || users_admin_index_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        set_classrooms
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
      format.html { redirect_to params[:url] || users_admin_index_path, notice: 'User was successfully destroyed.' }
      format.js
      format.json { head :no_content }
    end
  end

  def activities
    if @current_classroom
      @total_bg_statuses_hash = {}
      BubbleGroup.all.find_each do |bg|
        next unless @current_classroom_type.bubble_groups.include? bg
        bg_status = @current_classroom.bubble_group_statuses.general.where(bubble_group:bg).first_or_initialize
        @total_bg_statuses_hash[bg.id] = {}
        @total_bg_statuses_hash[bg.id][:bubble_group] = bg
        @total_bg_statuses_hash[bg.id][:global_bg_status] = bg_status
        @current_classroom.students.each do |kid|
          bg_status = kid.bubble_group_statuses.where(bubble_group: bg).first_or_initialize
          bg_status.active = BubbleGroupStatus::ACTIVE_NONE if bg_status.new_record?
          @total_bg_statuses_hash[bg.id][:kid_bg_statuses] ||= {}
          @total_bg_statuses_hash[bg.id][:kid_bg_statuses][kid.id] = bg_status
        end
      end
    end
    @active_bg_statuses = @total_bg_statuses_hash.select{|bg, bg_info| bg_info[:global_bg_status].active == BubbleGroupStatus::ACTIVE_ACTIVE }.inject([]){|arr, bg_info| arr << bg_info[1][:global_bg_status]}
    @time_options = [['Not Selected', nil],['1 Minutes', 1.minutes],['2 Hours', 2.hours], ['1 Day', 1.days], ['2 Days', 2.days], ['5 Days', 5.days]]
  end

  def dashboard_classroom
  end

  def dashboard
    @classroom_types = ClassroomType.all
    if current_user.admin?
      @current_school = School.all.sample
    else
      @current_school = current_user.school
    end
    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
      @current_school = @current_classroom.school
    else
      @current_classroom = current_user.teacher? ? current_user.classroom : @current_school.classrooms.sample
    end
    if params.has_key? :school
      @current_school = School.find(params[:school])
      @current_classroom = @current_school.classrooms.sample
    end

    if @current_classroom
      @time_intervals_and_kids = []
      kids = @current_classroom.students.includes(:kid_activities)
      if KidActivity.joins(:bubble_group_status).where(bubble_group_statuses:{kid_id: kids.pluck(:id), active: BubbleGroupStatus::ACTIVE_ACTIVE}).any?
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
      classrooms = current_user.admin? ? @current_school.classrooms : [@current_classroom]
      classrooms.group_by(&:classroom_type_id).each do |ct_id, classrooms|
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
            (bg.bubble_categories.uniq & ct.bubble_categories.uniq).sort_by{|ct| ct.name.split('-').first.to_i}.each do |category|
              total_count = category.bubbles.count * cr.students.count
              passed_count = category.bubbles.joins(bubble_statuses: :bubble_group_status).where(bubble_statuses:{passed:true}, bubble_group_statuses:{kid_id:cr.students.pluck(:id)}).count.to_f
              @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name][:categories][category.name] = {
                passed: passed_count / total_count * 100
              }
            end
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

  def update_classrooms
    set_classrooms
    @role               = Role.where.not(name: 'Parent').find_by(id: params[:role_id])
    @classroom          = Classroom.find_by(id:params[:classroom_id], school: @school)
    @classroom_teachers = @classroom.teachers if @classroom
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :avatar, :last_name, :email, :direct_phone, :role_id, :classroom_id, :school_id)
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
          @school_hash[school.id][:classrooms][classroom_type.id] = classrooms.map{|cr| [cr.id, cr.name, cr.teachers.map(&:id)]}
        end
      end
      if current_user.admin?
        classrooms = Classroom.all
        @classroom_types = ClassroomType.all
      else
        if current_user.teacher?
          classrooms = Classroom.where(school: current_user.school, id: current_user.classroom)
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
      if @current_classroom
        @current_school = @current_classroom.school
        if params.has_key? :school
          @current_school = School.find(params[:school])
          @current_classroom = @current_school.classrooms.sample
        end
        @current_classroom_type = @current_classroom.try(:classroom_type)

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

    def set_available_data
      @roles = Role.where.not(name: 'Parent').to_a
      @roles.unshift(OpenStruct.new(id:nil, name: 'Choose Role'))
      @schools = School.all.to_a
      @schools.unshift(OpenStruct.new(id:nil, name: 'Choose School'))
    end

    def set_classrooms
      @school = School.find_by(id:params[:school_id]) || @user.try(:school)
      @classrooms = @school.try(:classrooms).to_a
      @classrooms.unshift(OpenStruct.new(id:nil, name: 'Choose Classroom'))
    end
end
