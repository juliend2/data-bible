class ExcerptsController < ApplicationController
  def index
  end

  def show
  end

  def tags
    render json: Excerpt.find(params[:id]).tags
  end

  def note
    @note = Excerpt.find(params[:id]).note || ''
    render layout: false
  end

  def notes
    @excerpts_with_notes = Excerpt.where.not(note: nil)
  end

  def delete
    if Excerpt.find(params[:id]).destroy
      render json: {status: 'success'}
    else
      render json: {status: 'error'}
    end
  end
end
