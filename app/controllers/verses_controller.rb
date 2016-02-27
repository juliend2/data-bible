class VersesController < ApplicationController
  def search
    @query = params[:query]
    if @query
      @verse_versions = VerseVersion.where("content LIKE '%#{@query}%' AND version_id = #{current_version.id}").includes(:verse)
    else
      @verse_versions = []
    end
  end

  def word_cloud
    @books = Book.all
  end
end
