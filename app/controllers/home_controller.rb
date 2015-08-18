class HomeController < ApplicationController
  def index
    unless user_signed_in?
  		redirect_to new_user_session_path
  	end
  end

  def choose_school
  end

  def set_school
    self.current_school = params[:school_id] unless params[:school_id].blank?
    redirect_to dashboard_path
  end

  def activities
    if current_user.teacher?
      classrooms = Classroom.where(school: current_school, user: current_user)
      @classroom_types = ClassroomType.joins(:classrooms).merge(classrooms).uniq
    else
      classrooms = Classroom.all
      @classroom_types = ClassroomType.all
    end

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
    
    @total_assignments_hash = {}
    BubbleGroup.all.find_each do |bg|
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

    @time_options = [['None', nil], ['2 Hours', 2.hours], ['1 Day', 1.days], ['2 Days', 2.days], ['5 Days', 5.days]]
  end

end
