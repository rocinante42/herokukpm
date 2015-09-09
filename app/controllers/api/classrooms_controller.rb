class Api::ClassroomsController < Api::ApiController
  def index
    @classrooms = Classroom.all
  end

  def show
    @classroom = Classroom.find(params[:id])
  end
end
