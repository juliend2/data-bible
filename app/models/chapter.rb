class Chapter < ActiveRecord::Base
  belongs_to :book
  has_many :verses

  # Returns an Array of Excerpt objects, related to current Chapter instance
  def excerpts
    verse_ids = self.verses.select(:id).map(&:id)
    ExcerptVerse.where(verse_id: verse_ids).includes(:excerpt).map(&:excerpt)
  end
end
