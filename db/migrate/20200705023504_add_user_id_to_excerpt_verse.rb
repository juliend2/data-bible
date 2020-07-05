class AddUserIdToExcerptVerse < ActiveRecord::Migration
  def change
    add_column :excerpt_verses, :user_id, :integer
  end
end
