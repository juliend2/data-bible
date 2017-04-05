class VersesController < ApplicationController
  def search
    @query = params[:query]
    @books = Book.all
    @book_ids = params[:book_id] ? params[:book_id].map(&:to_i) : []
    if @query
      if @book_ids && !@book_ids.empty?
        search_query = SearchQuery.new(@query)
        @verse_versions = VerseVersion.find_by_sql [<<-EOSQL, @book_ids]
          SELECT  verse_versions.*
          FROM    verse_versions
            JOIN  verses ON verses.id = verse_versions.verse_id
            JOIN  chapters ON chapters.id = verses.chapter_id
            JOIN  books ON books.id = chapters.book_id
          WHERE   (#{search_query.to_sql})
            AND   verse_versions.version_id = #{current_version.id}
            AND   books.id IN (?)
        EOSQL
      else
        @verse_versions = VerseVersion.where("content LIKE '%#{@query}%' AND version_id = #{current_version.id}").includes(:verse)
      end
    else
      @verse_versions = []
    end
  end

  def word_cloud
    @books = Book.all
  end
end
