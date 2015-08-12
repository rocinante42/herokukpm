class HomeController < ApplicationController
  def index
    unless user_signed_in?
  		redirect_to new_user_session_path
  	end
  end

  def dashboard
    @classrooms = current_user.classrooms
  end
end
