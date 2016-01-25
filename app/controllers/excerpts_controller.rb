class ExcerptsController < ApplicationController
  def index
  end

  def show
  end

  def tags
    render json: Excerpt.find(params[:id]).tags
  end
end
