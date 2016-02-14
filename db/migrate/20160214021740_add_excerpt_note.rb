class AddExcerptNote < ActiveRecord::Migration
  def change
    add_column :excerpts, :note, :text, null: true
  end
end
