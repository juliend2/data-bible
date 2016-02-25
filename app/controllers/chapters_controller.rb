class ChaptersController < ApplicationController
  def index
    @books = Book.all
  end

  def read
    @available_versions = Version.all
    @book = Book.find_by_number(params[:book_number])
    @chapter = @book.chapters.find_by_number(params[:chapter_number])
    @chapter_excerpts = @chapter.excerpts
    @chapter_tags = @chapter_excerpts.
      compact. # Just in case some excerpts are nil (not much chance it happens)
      map{|excerpt| excerpt.tags }.
      flatten.
      uniq{|t| t.id}
    @all_versions = Version.all
    if params[:versions] && params[:versions] != '' && params[:versions] != current_version.slug
      @versions = params[:versions].split(/,/).map{|version_slug| Version.where(slug: version_slug).first }
    else
      @version = current_version
      unless @version
        flash[:notice] = "Please choose a Bible version"
        redirect_to choose_version_path
      end
    end
    @tags = Tag.order(:name).all
  end

  def chapter_only
    @book = Book.find_by_number(params[:book_number])
    @chapter = @book.chapters.find_by_number(params[:chapter_number])
    if params[:versions]
      @versions = params[:versions].split(/,/).map{|version_slug| Version.where(slug: version_slug).first }
    else
      @version = current_version
    end
    render layout: false
  end
end
