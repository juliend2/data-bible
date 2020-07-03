# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


book_names = {
 "Genèse" => ['Moïse'],
 "Exode"=> ['Moïse'],
 "Lévitique"=> ['Moïse'],
 "Nombres"=> ['Moïse'],
 "Deutéronome"=> ['Moïse'],
 "Josué"=> ['Josué'],
 "Juges"=> ['inconnu'],
 "Ruth"=> ['inconnu'],
 "1 Samuel"=> ['inconnu'],
 "2 Samuel"=> ['inconnu'],
 "1 Rois"=> ['inconnu'],
 "2 Rois"=> ['inconnu'],
 "1 Chroniques"=> ['Esdras'],
 "2 Chroniques"=> ['Esdras'],
 "Esdras"=> ['Esdras'],
 "Néhémie"=> ['Esdras'],
 "Esther"=> ['inconnu'],
 "Job"=> ['inconnu'],
 "Psaumes"=> ['Éthan', 'Asaph', 'les fils de Koré', 'Héman', 'Salomon', 'David'],
 "Proverbes"=> ['Salomon', 'Agur', 'Ézéchias'],
 "Ecclésiaste"=> ['Salomon'],
 "Cantique des cantiques"=> ['Salomon'],
 "Esaïe"=> ['Ésaïe'],
 "Jérémie"=> ['Jérémie'],
 "Lamentations"=> ['inconnu'],
 "Ezéchiel"=> ['Ezéchiel'],
 "Daniel"=> ['Daniel'],
 "Osée"=> ['Osée'],
 "Joël"=> ['Joël'],
 "Amos"=> ['Amos'],
 "Abdias"=> ['Abdias'],
 "Jonas"=> ['Jonas'],
 "Michée"=> ['Michée'],
 "Nahum"=> ['Nahum'],
 "Habakuk"=> ['Habakuk'],
 "Sophonie"=> ['Sophonie'],
 "Aggée"=> ['Aggée'],
 "Zacharie"=> ['Zacharie'],
 "Malachie"=> ['Malachie'],
 "Matthieu"=> ['Matthieu'],
 "Marc"=> ['Marc'],
 "Luc"=> ['Luc'],
 "Jean"=> ['Jean'],
 "Actes des apôtres"=> ['Luc'],
 "Romains"=> ['Paul'],
 "1 Corinthiens"=> ['Paul'],
 "2 Corinthiens"=> ['Paul'],
 "Galates"=> ['Paul'],
 "Ephésiens"=> ['Paul'],
 "Philippiens"=> ['Paul'],
 "Colossiens"=> ['Paul'],
 "1 Thessaloniciens"=> ['Paul'],
 "2 Thessaloniciens"=> ['Paul'],
 "1 Timothée"=> ['Paul'],
 "2 Timothée"=> ['Paul'],
 "Tite"=> ['Paul'],
 "Philémon"=> ['Paul'],
 "Hébreux"=> ['inconnu'],
 "Jacques"=> ['Jacques'],
 "1 Pierre"=> ['Pierre'],
 "2 Pierre"=> ['Pierre'],
 "1 Jean"=> ['Jean'],
 "2 Jean"=> ['Jean'],
 "3 Jean"=> ['Jean'],
 "Jude"=> ['Jude'],
 "Apocalypse"=> ["Jean l'ancien"],
}
book_number = 1
book_names.each do |book_name, author_names|
  book = Book.find_by_name(book_name)
  p book.inspect
  if book.nil?
    puts "NO BOOKO"
    book = Book.new(number: book_number, name: book_name)
  end
  authors = []
  puts author_names.inspect
  author_names.each do |author_name|
    a = Author.find_by_name(author_name)
    authors <<
      if a
        a
      else
        Author.create(name: author_name)
      end
  end
  book.authors = authors
  book.save

  book_number += 1
end
