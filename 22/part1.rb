def process(input)
  decks = input.split(/\n\n/).map { |deck| deck.split(/\n/)[1..-1].map(&:to_i) }
  loop do
    break if decks.any?(&:empty?)
    card1, card2 = decks.map(&:shift)
    if card1 > card2
      decks.first << card1 << card2
    else
      decks.last << card2 << card1
    end
  end
  decks.reduce(:+).reverse.each_with_index.map { |card, index| card * (index + 1) }.sum
end

puts process(File.read('input'))
