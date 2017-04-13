class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :description, null: true

      t.timestamps null: false
    end

    create_table :authors_books do |t|
      t.belongs_to :author, index: true
      t.belongs_to :book, index: true

      t.timestamp null: false
    end
  end
end
