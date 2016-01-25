class Version < ActiveRecord::Base
  has_many :verse_versions
  has_many :verses, through: :verse_versions
end
