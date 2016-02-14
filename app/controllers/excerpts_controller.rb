class ExcerptsController < ApplicationController
  def index
  end

  def show
  end

  def tags
    render json: Excerpt.find(params[:id]).tags
  end

  def note
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @html = markdown.render(Excerpt.find(params[:id]).note || '')
    render layout: false
  end

  def delete
    if Excerpt.find(params[:id]).destroy
      render json: {status: 'success'}
    else
      render json: {status: 'error'}
    end
  end
end
