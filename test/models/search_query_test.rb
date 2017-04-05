require 'test_helper'

class SearchQueryTest < ActiveSupport::TestCase
  # setup do
  # end

  test "query" do
    @query = SearchQuery.new '"joie cool" || bob'
    assert @query.tokens.find{|t| t[0] == :QUOTED_STRING}, "has a quoted String"
    assert @query.tokens.find{|t| t[0] == :STRING}, "has a String"
  end

  test "returned SQL conditions" do
    @query = SearchQuery.new 'joie || poulet'
    puts @query.to_sql
    assert @query.to_sql == "verse_versions.content LIKE '%joie%' OR verse_versions.content LIKE '%poulet%'"
  end

end
