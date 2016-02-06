class Book < ActiveRecord::Base
  has_many :chapters

  def words_by_popularity
    max_word_per_book = 20
    words = []
    excluded_words = (%w[
      notre votre leur
      nos vos leurs
      à après avant avec chez contre dans de depuis derrière dès devant en entre envers malgré
      par parmis pendant pour près sans selon sous sur vers voici voilà
      je tu il elle nous vous ils elles
      que qu se ne pas du de et au tout quil quils
      un une des
      son sa ses
      mon ma mes
      le la les
      ton ta tes
      toi ce où lui dit qui est moi toi était avait
      tous tout toute toutes
      donc ainsi même suis eux aux ou ni afin
      cela cet cette ces ceux celles celui parmi autre quoi autres autre
      plus puis encore sera où cest mais deux cette quand ans comme dont pourquoi répondit quant
      étaient ai aurais eut commit prit appela donna fait fit fut vis vit ont leva fais faire mit dis avez dirent être avoir été jai aura donne sont soit avons avaient feras fera peut sais rendons rendu
      êtes seront ferai aucun seront parlait déclare
      le me on te car si ta là alors aussi as jusqu parce aujourd hui fois lorsque quelqu
      000 pause
    ] + (1..9).to_a + ('a'..'z').to_a + [""]).flatten.map(&:to_s).uniq
    vv = Rails.cache.fetch("#{cache_key}/verse_content", expires_in: 12.hours) {
      version = Version.find_by_slug('SG21')
      VerseVersion.find_by_sql(<<-EOSQL)
        SELECT  verse_versions.content
        FROM    verse_versions
          JOIN  verses ON verses.id = verse_versions.verse_id
          JOIN  chapters ON chapters.id = verses.chapter_id
          JOIN  books ON books.id = chapters.book_id
        WHERE   books.id = #{id}
          AND   verse_versions.version_id = #{version.id}
      EOSQL
    }
    

    # tokenize
    words = vv.
      map {|v| v.content.split(/ /) }.flatten.
      map {|word| word.split(/[’'-]/) }.flatten.
      map {|word| word.gsub(/[^[:word:]\s]/, '') }.map(&:downcase)

    # exclude some words
    words = words - excluded_words
    words.reject! {|word| word.size == 2 }

    # calculate frequency
    frequency = Hash.new(0)
    words.each { |word| frequency[word.downcase] += 1 }
    frequency.
      sort_by {|_key, value| value}.
      reverse[0..max_word_per_book]
  end
end
