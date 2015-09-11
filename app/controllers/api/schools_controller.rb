class Api::SchoolsController < Api::ApiController
  before_action :authenticate

  def index
    @schools = School.all
  end

  def show
    @school = School.find(params[:id])
  end
end
