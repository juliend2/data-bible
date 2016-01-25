# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :default => :spec

desc "Run the seed"
namespace :db do
  task :seed do
    json_path = ENV['JSON_PATH']
    version_id = ENV['VERSION_ID']

    json_text = File.read json_path
    bible = JSON.parse json_text, symbolize_names: true
    version = Version.find(version_id)

    book_index = 1

    # TODO: make the creation of Book, Chapter and Verse idempotent.
    # We don't want multiple versions of these objects in the db.
    bible[:Testaments].each do |t|
      t[:Books].each do |book|
        puts "#{book_index} : #{book[:Text]}"
        bk = Book.new(name: book[:Text], number: book_index)
        bk.save
        chapter_index = 1
        book[:Chapters].each do |chapter|
          chap = Chapter.new(book: bk, number: chapter_index)
          chap.save
          chapter[:Verses].each do |verse|
            verse_number = verse.has_key?(:ID) ? verse[:ID] : 1
            ver = Verse.new(number: verse_number, chapter: chap)
            vversion = VerseVersion.new(verse: ver, version: version, content: verse[:Text])
            vversion.save
            ver.verse_versions << vversion
            ver.save
          end
          chapter_index += 1
        end
        book_index += 1
      end
    end
  end
end

# Book.destroy_all
# Chapter.destroy_all
# Verse.destroy_all
# VerseVersion.destroy_all
# ExcerptVerse.destroy_all
# Excerpt.destroy_all
#
# env JSON_PATH=./db/seed_data/french_louis_segond_1910.json VERSION_ID=1 rake db:seed
