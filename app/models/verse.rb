class Verse < ActiveRecord::Base
  belongs_to :chapter
  has_many :excerpt_verses
  has_many :excerpts, through: :excerpt_verses
  has_many :verse_versions
  has_many :versions, through: :verse_versions
end
