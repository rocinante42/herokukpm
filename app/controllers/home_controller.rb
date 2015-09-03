  class HomeController < ApplicationController

  before_action :set_available_classrooms, only: [:activities, :dashboard_classroom]
  def index
    unless user_signed_in?
      redirect_to new_user_session_path
    else
      redirect_to dashboard_path
    end
  end

  def choose_school
  end

  def set_school
    self.current_school = params[:school_id] unless params[:school_id].blank?
    redirect_to dashboard_path
  end

  def activities
    @classroom_hash = {}
    @classroom_types.each do |ct|
      current_classrooms = ct.classrooms
      if current_user.teacher?
        current_classrooms = current_classrooms.where(school: current_school, teacher: current_user)
      elsif current_user.teacher_admin?
        current_classrooms = current_classrooms.where(school: current_user.school)
      end
      @classroom_hash[ct.id] = current_classrooms.pluck(:id, :name)
    end 
    
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

  def dashboard
    @classroom_types = ClassroomType.all
    if current_user.admin?
      @classrooms = Classroom.all
    elsif current_user.teacher?
      @classrooms = Classroom.where(school: current_school, teacher: current_user)
    else
      @classrooms = Classroom.where(school: current_user.school)
    end
    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
    else
      @current_classroom = @classrooms.sample
    end

    @time_intervals_and_kids = []
    kids = @current_classroom.kids.includes(:kid_activities)
    if KidActivity.joins(:assignment).where(assignments:{kid_id: kids.pluck(:id)}).any?
      kids_time = kids.map{|kid| kid.kid_activities.where(updated_at:[7.days.ago..Time.now]).map(&:total_time).inject(:+)}
      max_time = kids_time.max{|a,b| a <=> b }
      step = max_time / 5
      steps = (0..max_time).step(step).to_a
      time_intervals_in_seconds = steps.map.with_index{|el, index| [el, steps[index+1]]}[0...-1]
      time_intervals_in_minutes = time_intervals_in_seconds.map{|step| [(step[0]/60).round, (step[1]/60).round]}
      time_intervals_in_minutes.each_with_index do |ti, index|
        selected_kids = kids.select{|kid| (ti[0]..ti[1]).include? (kid.kid_activities.where(updated_at:[7.days.ago..Time.now]).map(&:total_time).inject(:+)/60).round}
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
      @bottom_current_classroom_type = @classroom_types.joins(:classrooms).merge(@classrooms).first
      @bottom_current_classroom = @bottom_current_classroom_type.classrooms.first
    end
    @total_hash = {}
    @classrooms.group_by(&:classroom_type_id).each do |ct_id, classrooms|
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
          bg.bubble_categories.each do |category|
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
                        'View Schools' => schools_path
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

  def dashboard_classroom
    @classroom_hash = {}
    @classroom_types.each do |ct|
      current_classrooms = ct.classrooms
      if current_user.teacher?
        current_classrooms = current_classrooms.where(school: current_school, teacher: current_user)
      elsif current_user.teacher_admin?
        current_classrooms = current_classrooms.where(school: current_user.school)
      end
      @classroom_hash[ct.id] = current_classrooms.pluck(:id, :name)
    end
  end

  private

  def set_available_classrooms
    if current_user.admin?
      classrooms = Classroom.all
      @classroom_types = ClassroomType.all
    else
      if current_user.teacher?
        classrooms = Classroom.where(school: current_school, teacher: current_user)
      else
        classrooms = Classroom.where(school: current_user.school)
      end
      @classroom_types = ClassroomType.joins(:classrooms).merge(classrooms).uniq
    end
    if params.has_key? :classroom
      @current_classroom = Classroom.find(params[:classroom])
      @current_classroom_type = @current_classroom.classroom_type
    else
      @current_classroom = classrooms.sample
      @current_classroom_type = @current_classroom.classroom_type
    end
  end

end
