class TagsController < ApplicationController
  def index
  end

  def assign
    book = Book.find_by_number(params[:book])
    chapter = book.chapters.find_by_number(params[:chapter])
    verses = chapter.verses.where(number: params[:verses].map(&:to_i))
    excerpt = Excerpt.new
    excerpt.verses = verses
    tags = []
    params[:tags].each do |tag|
      db_tag = Tag.find_by_name(tag)
      unless db_tag
        db_tag = Tag.new(name: tag)
        db_tag.save
      end
      tags << db_tag
    end
    excerpt.tags = tags
    saved_excerpt = excerpt.save
    if saved_excerpt
      render json: {status: 'success'}
    else
      render json: {status: 'error'}
    end
  end
end
