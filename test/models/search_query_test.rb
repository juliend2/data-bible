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
    assert_equal "verse_versions.content LIKE '%joie%' OR verse_versions.content LIKE '%poulet%'", @query.to_sql, "Not the same"
  end

  test "handles parentheses" do
    @query = SearchQuery.new "joie && (Jésus || Christ)"
    assert_equal "verse_versions.content LIKE '%joie%' AND (verse_versions.content LIKE '%Jésus%' OR verse_versions.content LIKE '%Christ%')", @query.to_sql, "Not the same"
  end

end
