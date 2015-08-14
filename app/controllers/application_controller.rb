class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :teacher_requires_school, :clear_current_school
  helper_method :current_school

  rescue_from CanCan::AccessDenied do |exception|
  flash[:error] = "Access denied!"
  redirect_to root_url
  end

  def current_school=(school_id)
    session[:school_id] = school_id
  end

  def current_school
    @current_school ||= School.find(session[:school_id])
  end

  def teacher_requires_school
    paths = [choose_school_path, destroy_user_session_path, set_school_path]
    if user_signed_in? && current_user.teacher? && !paths.include?(request.path)
      unless session[:school_id]
        if current_user.schools.count == 1
          self.current_school = current_user.schools.first.id
          redirect_to dashboard_path
        else
          redirect_to choose_school_path
        end
      end
    end
  end

  def clear_current_school
    self.current_school = nil if current_user.teacher? && request.path == destroy_user_session_path
  end

end
