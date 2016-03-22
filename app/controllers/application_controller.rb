class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :redirect_parent_to_kid_report, :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
      headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
  if request.method == :options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    render :text => '', :content_type => 'text/plain'
  end
end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied!"
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path
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
