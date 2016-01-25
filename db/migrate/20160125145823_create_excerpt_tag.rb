class CreateExcerptTag < ActiveRecord::Migration
  def change
    create_table :excerpt_tags do |t|
      t.belongs_to :excerpt, index: true
      t.belongs_to :tag, index: true

      t.timestamps null: false
    end
  end
end
