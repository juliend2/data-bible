class CreateExcerptVerse < ActiveRecord::Migration
  def change
    create_table :excerpt_verses do |t|
      t.belongs_to :verse, index: true
      t.belongs_to :excerpt, index: true

      t.timestamps null: false
    end
  end
end
