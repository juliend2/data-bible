require 'json'
require 'sequel'
require 'pp'

DB = Sequel.connect ENV['DATABASE_CONFIG']

json_path = ARGV.shift
translation_id = ARGV.shift

json_text = File.read json_path
bible = JSON.parse json_text, symbolize_names: true

# Import Books
book_index = 1
bible[:Testaments].each do |t|
  t[:Books].each do |book|
    puts "#{book_index} : #{book[:Text]}"
    DB[:books].insert(book_id: book_index, name: book[:Text])
    chapter_index = 1
    book[:Chapters].each do |chapter|
      DB[:chapters].insert(chapter_number: chapter_index, book_id: book_index)
      chapter[:Verses].each do |verse|
        verse_number = verse.has_key?(:ID) ? verse[:ID] : 1
        DB[:verses].insert(verse_number: verse_number, chapter_number: chapter_index,
                           book_id: book_index)
        DB[:scriptures].insert(verse_number: verse_number, translation_id: '57d6109d-5bd4-43fd-bdba-b7acbbe10d46',
                               content: verse[:Text], chapter_number: chapter_index,
                               book_id: book_index)
      end
      chapter_index += 1
    end
    book_index += 1
  end
end
