class VersionsController < ApplicationController
  def choose_version
    session[:return_to] ||= request.referer
    @available_versions = Version.all
  end

  def set_version
    session[:current_version_id] = params[:version_id]
    redirect_to session.delete(:return_to)
  end
end
