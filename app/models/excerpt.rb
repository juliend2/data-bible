class Excerpt < ActiveRecord::Base
  has_many :excerpt_verses
  has_many :verses, through: :excerpt_verses
  has_many :excerpt_tags
  has_many :tags, through: :excerpt_tags

  before_destroy :destroy_excerpt_tags, :destroy_excerpt_verses

  private

  def destroy_excerpt_verses
    self.excerpt_verses.destroy_all
  end

  def destroy_excerpt_tags
    self.excerpt_tags.destroy_all
  end
end
