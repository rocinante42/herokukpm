class Api::ClassroomsController < Api::ApiController
  before_action :authenticate

  def index
    @classrooms = Classroom.all
  end

  def show
    @classroom = Classroom.find(params[:id])
  end
end
