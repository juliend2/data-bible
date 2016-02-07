class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_version
    if session[:current_version_id]
      @current_version ||= session[:current_version_id] && Version.find(session[:current_version_id])
    end
  end
  helper_method :current_version
end
