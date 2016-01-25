class CreateVersion < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
