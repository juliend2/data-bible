class Book < ActiveRecord::Base
  has_many :chapters
end
