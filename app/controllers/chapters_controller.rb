class ChaptersController < ApplicationController
  def index
    @books = Book.all
  end

  def read
    @book = Book.find_by_number(params[:book_number])
    @chapter = @book.chapters.find_by_number(params[:chapter_number])
    @version = Version.find_by_slug('SG21')
    @tags = Tag.all
  end
end
