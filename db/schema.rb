# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200705021325) do

  create_table "authors", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "authors_books", force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  add_index "authors_books", ["author_id"], name: "index_authors_books_on_author_id"
  add_index "authors_books", ["book_id"], name: "index_authors_books_on_book_id"

  create_table "books", force: :cascade do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "number"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chapters", ["book_id"], name: "index_chapters_on_book_id"

  create_table "excerpt_tags", force: :cascade do |t|
    t.integer  "excerpt_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "excerpt_tags", ["excerpt_id"], name: "index_excerpt_tags_on_excerpt_id"
  add_index "excerpt_tags", ["tag_id"], name: "index_excerpt_tags_on_tag_id"

  create_table "excerpt_verses", force: :cascade do |t|
    t.integer  "verse_id"
    t.integer  "excerpt_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "excerpt_verses", ["excerpt_id"], name: "index_excerpt_verses_on_excerpt_id"
  add_index "excerpt_verses", ["verse_id"], name: "index_excerpt_verses_on_verse_id"

  create_table "excerpts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "note"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "verse_versions", force: :cascade do |t|
    t.integer  "verse_id"
    t.integer  "version_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "verse_versions", ["verse_id"], name: "index_verse_versions_on_verse_id"
  add_index "verse_versions", ["version_id"], name: "index_verse_versions_on_version_id"

  create_table "verses", force: :cascade do |t|
    t.integer  "number"
    t.integer  "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "verses", ["chapter_id"], name: "index_verses_on_chapter_id"

  create_table "versions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

end
