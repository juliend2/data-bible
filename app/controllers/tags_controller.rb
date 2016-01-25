class TagsController < ApplicationController
  def index
  end

  def assign
    # 1. Get the Verses by numbers
    # 2. Create an Excerpt with these verses
    # 3. Loop into the Tags we got, and for each one of them:
    #   a) verify if a Tag with this name already exists, and if NOT, create it
    #   b) assign all the tags (including the newly-created ones) to the Excerpt we created
    # 4. if the Excerpt properly saved (returns False otherwise); success
    book = Book.find_by_number(params[:book])
    chapter = book.chapters.find_by_number(params[:chapter])
    # byebug
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
