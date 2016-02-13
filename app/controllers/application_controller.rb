class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_version
    if session[:current_version_id]
      @current_version ||= session[:current_version_id] && Version.find(session[:current_version_id])
    else
      Version.first
    end
  end
  helper_method :current_version
end
