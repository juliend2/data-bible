class CreateExcerpts < ActiveRecord::Migration
  def change
    create_table :excerpts do |t|

      t.timestamps null: false
    end
  end
end
