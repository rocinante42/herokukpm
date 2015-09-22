class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token, :only => [:bulk_submit, :bulk_update]

  respond_to :html

  def index
    @assignments = Assignment.all
    respond_with(@assignments)
  end

  def show
    respond_with(@assignment)
  end

  def new
    @assignment = Assignment.new
    respond_with(@assignment)
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.save
    redirect_to :back
  end

  def update
    @assignment.update(assignment_params)
    redirect_to :back
  end

  def destroy
    @assignment.destroy
    respond_with(@assignment)
  end

  def bulk_submit
    classroom = Classroom.find(params[:classroom_id])
    bubble_groups = params[:all] ? classroom.bubble_groups : classroom.bubble_groups.where(id: params[:bubble_groups])
    time_limits = params[:all] ? Array.new(bubble_groups.count, params[:time_limit]) : params[:time_limit]
    bubble_groups.each_with_index do |bg, index|
      next if time_limits[index].blank?
      assignment = Assignment.where(bubble_group:bg, classroom:classroom).first_or_initialize
      assignment.status = Assignment::ACTIVE
      assignment.time_limit = time_limits[index]
      assignment.save!
    end
    redirect_to :back
  end

  def bulk_update
    @classroom = Classroom.find(params[:classroom_id])
    @classroom.assignments.each do |assignment|
      assignment.update(status:params[:status])
    end
    redirect_to :back
  end

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:kid_id, :bubble_group_id, :status, :time_limit, :classroom_id)
    end
end
