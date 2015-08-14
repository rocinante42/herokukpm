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

end
