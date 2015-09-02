class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

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
    classroom = Classroom.find(params[:classroom])
    BubbleGroup.all.find_each do |bg|
      next unless classroom.classroom_type.bubble_groups.include? bg
      assignment = Assignment.where(bubble_group:bg, classroom:classroom).first_or_initialize
      assignment.status = Assignment::ACTIVE
      assignment.time_limit = params[:time_limit]
      assignment.save!
    end
    redirect_to :back
  end

  def bulk_update
    @classroom = Classroom.find(params[:classroom])
    @classroom.assignments.update_all(status: params[:status])
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
