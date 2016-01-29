class VersesController < ApplicationController
  def search
    @query = params[:query]
    @verse_versions = VerseVersion.where("content LIKE '%#{@query}%'").includes(:verse)
  end
end
