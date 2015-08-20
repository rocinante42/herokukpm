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

  def dashboard
    @classroom_types = ClassroomType.all
    @classrooms = current_user.teacher? ? Classroom.where(school: current_school, user: current_user) : Classroom.all
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

=begin
    @current_classroom_hash = {}

    @bottom_current_classroom_type = @classroom_types.sample
    if params.has_key? :current_ct
      @bottom_current_classroom_type = ClassroomType.find(params[:current_ct])
      @bottom_current_classroom = @bottom_current_classroom_type.classrooms.sample
    end
    if params.has_key? :current_cr
      @bottom_current_classroom = Classroom.find(:current_cr)
    end
    @bottom_current_classroom = Classroom.first
    @current_classroom_hash[:bubble_groups] = {}
    @bottom_current_classroom_type.bubble_groups.each do |bg|
      @current_classroom_hash[:bubble_groups][bg.name] = {
        categories: {}
      }
      bg.bubble_categories.each do |category|
        @current_classroom_hash[:bubble_groups][bg.name][:categories][category.name] = {}
        passed_kids_count = @bottom_current_classroom.kids.joins(bubble_statuses: :bubble).where(bubble_statuses:{passed: true}, bubbles: {bubble_category_id: category.id}).count.to_f
        @current_classroom_hash[:bubble_groups][bg.name][:categories][category.name] = {
          passed: (passed_kids_count / @bottom_current_classroom.kids.count) * 100
        }
      end
    end
    #puts "total_hash #{@current_classroom_hash.inspect}"
=end
    @bottom_current_classroom_type = @classroom_types.first
    @bottom_current_classroom = @bottom_current_classroom_type.classrooms.first
    @total_hash = {}
    puts "groups!!! #{@classrooms.group_by(&:classroom_type_id).inspect}"
    @classrooms.group_by(&:classroom_type_id).each do |ct_id, classrooms|
      ct = ClassroomType.find(ct_id)
      ct_name = ct.type_name
      @total_hash[ct_name] = {
        #bubble_groups: ct.bubble_groups.pluck(:name)
      }
      @total_hash[ct_name][:classrooms] = {}
      classrooms.each do |cr|
        #@total_hash[ct_name][:classrooms][dr.id]
        @total_hash[ct_name][:classrooms][cr.id] = {}
        @total_hash[ct_name][:classrooms][cr.id][:classroom] = cr
        @total_hash[ct_name][:classrooms][cr.id][:bubble_groups] = {}
        ct.bubble_groups.each do |bg|
          @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name] = {}
          @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name][:categories] = {}
          bg.bubble_categories.each do |category|
            passed_kids_count = cr.kids.joins(bubble_statuses: :bubble).where(bubble_statuses:{passed: true}, bubbles: {bubble_category_id: category.id}).count.to_f
            @total_hash[ct_name][:classrooms][cr.id][:bubble_groups][bg.name][:categories][category.name] = {
              passed: (passed_kids_count / cr.kids.count) * 100
            }
          end
        end
      end
    end
    puts "total_hash #{@total_hash.inspect}"

    respond_to do |format|
      format.html
      format.js
    end
  end

end
