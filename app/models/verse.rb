class Verse < ActiveRecord::Base
  belongs_to :chapter
  has_many :excerpt_verses
  has_many :excerpts, through: :excerpt_verses
  has_many :verse_versions
  has_many :versions, through: :verse_versions

  def excerpts_with_verse_as_first
    excerpts_with_verse = self.excerpts.select{|ex| ex.verses.order(:number).first.id == self.id }
  end

  def excerpts_with_verse_as_last
    excerpts_with_verse = self.excerpts.select{|ex| ex.verses.order(:number).last.id == self.id }
  end

  def starts_an_excerpt?
    if self.excerpts
      if excerpts_with_verse_as_first.size > 0
        return excerpts_with_verse_as_first
      end
    end
    false
  end

  def ends_an_excerpt?
    if self.excerpts
      if excerpts_with_verse_as_last.size > 0
        return excerpts_with_verse_as_last
      end
    end
    false
  end
end
