# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :default => :spec

desc "Run the seed"
namespace :db do
  task :seed do
    json_path = ENV['JSON_PATH']
    version_slug = ENV['VERSION_SLUG']

    # special case for default bible version
    if version_slug == 'LSG' && Version.find_by_slug('LSG').nil?
      version = Version.new(slug: version_slug, name: 'Louis Segond')
      version.save
    end

    json_text = File.read json_path
    bible = JSON.parse json_text, symbolize_names: true
    version = Version.where(slug: version_slug).first

    book_index = 1

    bible[:Testaments].each do |t|
      t[:Books].each do |book|
        puts "#{book_index} : #{book[:Text]}"
        bk = begin
               bk = Book.where(number: book_index).first
               unless bk
                 bk = Book.new(name: book[:Text], number: book_index)
                 bk.save
               end
               bk
             end
        chapter_index = 1
        book[:Chapters].each do |chapter|
          chap = begin
                   chap = Chapter.where(book: bk, number: chapter_index).first
                   unless chap
                     chap = Chapter.new(book: bk, number: chapter_index)
                     chap.save
                   end
                   chap
                 end
          chapter[:Verses].each do |verse|
            verse_number = verse.has_key?(:ID) ? verse[:ID] : 1
            ver = begin
                    ver = Verse.where(number: verse_number, chapter: chap).first
                    unless ver
                      ver = Verse.new(number: verse_number, chapter: chap)
                    end
                    ver
                  end
            vversion = begin
                         vversion = VerseVersion.where(verse: ver, version: version).first
                         unless vversion
                           vversion = VerseVersion.new(verse: ver, version: version, content: verse[:Text])
                           vversion.save
                           ver.verse_versions << vversion
                           ver.save
                         end
                       end
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
# env JSON_PATH=./db/seed_data/seg21-formatted.json VERSION_SLUG=SG21 rake db:seed
# env JSON_PATH=./db/seed_data/louis-segond-formatted.json VERSION_SLUG=LSG rake db:seed
