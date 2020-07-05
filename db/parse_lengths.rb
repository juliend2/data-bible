bag = {}
File.open('verse_lengths.csv').each do |line|
  line.strip!
  if bag.key? line
    bag[line] += 1
  else
    bag[line] = 1
  end
end

puts bag.inspect
