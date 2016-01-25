class Excerpt < ActiveRecord::Base
  has_many :excerpt_verses
  has_many :verses, through: :excerpt_verses
  has_many :excerpt_tags
  has_many :tags, through: :excerpt_tags
end
