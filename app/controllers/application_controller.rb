class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :teacher_requires_school, :clear_current_school, :redirect_parent_to_kid_report
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
    self.current_school = nil if user_signed_in? && current_user.teacher? && request.path == destroy_user_session_path
  end

  def redirect_parent_to_kid_report
    if user_signed_in? && current_user.parent?
      kids_reports_paths = current_user.kids.map{|kid| [reports_kid_path(kid), download_report_kid_path(kid)]}.flatten
      available_paths = kids_reports_paths << destroy_user_session_path
      unless kids_reports_paths.include? request.path
        redirect_to kids_reports_paths.first if kids_reports_paths.any?
      end
    end
  end

end
