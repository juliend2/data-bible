class CreateVerseVersion < ActiveRecord::Migration
  def change
    create_table :verse_versions do |t|
      t.belongs_to :verse, index: true
      t.belongs_to :version, index: true
      t.string :content

      t.timestamps null: false
    end
  end
end
