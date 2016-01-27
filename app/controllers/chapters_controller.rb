class ChaptersController < ApplicationController
  def index
    @books = Book.all
  end

  def read
    @book = Book.find_by_number(params[:book_number])
    @chapter = @book.chapters.find_by_number(params[:chapter_number])
    @chapter_excerpts = @chapter.excerpts
    @chapter_tags = @chapter_excerpts.
      compact. # Just in case some excerpts are nil (not much chance it happens)
      map{|excerpt| excerpt.tags }.
      flatten.
      uniq{|t| t.id}
    @version = Version.find_by_slug('SG21')
    @tags = Tag.all
  end
end
