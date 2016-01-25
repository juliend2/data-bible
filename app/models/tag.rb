class Tag < ActiveRecord::Base
  has_many :excerpt_tags
  has_many :excerpts, through: :excerpt_tags
end
