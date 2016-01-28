class Tag < ActiveRecord::Base
  has_many :excerpt_tags
  has_many :excerpts, through: :excerpt_tags

  before_destroy :destroy_excerpt_tags

  private

  def destroy_excerpt_tags
    self.excerpt_tags.destroy_all
  end
end
