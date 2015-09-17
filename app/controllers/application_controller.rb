class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :redirect_parent_to_kid_report

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end

  def redirect_parent_to_kid_report
    if user_signed_in? && current_user.parent?
      kids_reports_paths = current_user.kids.map{|kid| [reports_kid_path(kid), download_report_kid_path(kid)]}.flatten
      available_paths = kids_reports_paths  + [destroy_user_session_path, edit_user_registration_path, user_registration_path]
      unless available_paths.include? request.path
        redirect_to kids_reports_paths.first if kids_reports_paths.any?
      end
    end
  end

end
