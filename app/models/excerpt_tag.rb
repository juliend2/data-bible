class ExcerptTag < ActiveRecord::Base
  belongs_to :excerpt
  belongs_to :tag
end
