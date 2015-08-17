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
    #time_limit = Time.at(params[:assignment][:time_limit].to_i).utc.strftime("%H:%M:%S")
    #params[:assignment][:time_limit] = time_limit
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

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:kid_id, :bubble_group_id, :status, :time_limit)
    end
end
