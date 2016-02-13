class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    if params[:locale]
      session[:current_locale] = params[:locale]
      I18n.locale = current_locale
    end
  end

  def current_locale
    session[:current_locale] || I18n.default_locale
  end
  helper_method :current_locale

  def current_version
    if session[:current_version_id]
      @current_version ||= session[:current_version_id] && Version.find(session[:current_version_id])
    else
      Version.first
    end
  end
  helper_method :current_version
end
