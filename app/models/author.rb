class Author < ActiveRecord::Base
  has_many :authors_books
  has_many :books, through: :authors_books

  def self.books_by_authors
    self.all
  end
end
