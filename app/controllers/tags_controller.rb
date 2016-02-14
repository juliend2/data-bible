class TagsController < ApplicationController
  def index
    @tags = Tag.all.
      map{|tag| [tag, tag.name.parameterize] }.
      sort{|x,y| x.last <=> y.last }.
      group_by {|tag| tag.last[0] }.
      map{|letter, group| [letter, group.map(&:first)] }.
      to_h
  end

  def show
    @tag = Tag.find(params[:id])
    version = current_version
    excerpts = @tag.excerpts
    @excerpts_with_text = []
    excerpts.each do |excerpt|
      chapter = excerpt.verses.first.chapter
      book = chapter.book
      path = Rails.application.routes.url_helpers.chapter_read_path(book.number, chapter.number)
      @excerpts_with_text << excerpt.verses.map{|ver|
        text = VerseVersion.where(verse_id: ver.id, version_id: version.id).first.content
        verse_number = ver.number
        chapter = ver.chapter
        {path: path, verse_number: verse_number, chapter: chapter, text: text}
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
    # Are we assigning tags to this excerpt?
    if params[:tags].kind_of?(Array)
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
    end
    # Are we assigning a note to this excerpt?
    excerpt.note = params[:note] if params[:note]

    saved_excerpt = excerpt.save
    if saved_excerpt
      render json: {status: 'success'}
    else
      render json: {status: 'error'}
    end
  end

  def delete
    Tag.find(params[:id]).destroy
    redirect_to tags_index_url
  end
end
