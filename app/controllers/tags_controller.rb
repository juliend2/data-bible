class TagsController < ApplicationController
  def index
  end

  def show
    @tag = Tag.find(params[:id])
    version = Version.find_by_slug('SG21')
    excerpts = @tag.excerpts
    @excerpts_with_text = []
    excerpts.each do |excerpt|
      chapter = excerpt.verses.first.chapter
      book = chapter.book
      path = Rails.application.routes.url_helpers.chapter_read_path(book.number, chapter.number)
      @excerpts_with_text << excerpt.verses.map{|ver|
        text = VerseVersion.where(verse_id: ver.id, version_id: version.id).first.content
        verse_number = ver.number
        {path: path, verse_number: verse_number, text: text}
      }
    end
    @excerpts_with_text
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
