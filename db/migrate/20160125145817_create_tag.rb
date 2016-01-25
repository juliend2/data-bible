class CreateTag < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :description, null: true

      t.timestamps null: false
    end
  end
end
