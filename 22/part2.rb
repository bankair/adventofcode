def recursion(decks)
  previous = []
  round = 1
  loop do
    return [0, decks.first] if previous.include?(decks)
    previous += [decks.map(&:clone)]
    card1, card2 = decks.map(&:shift)
    winner =
      if decks.first.size >= card1 && decks.last.size >= card2
        winner, _winning_deck =
          recursion([card1, card2].each_with_index.map { |card, index| decks[index][0...card].clone })
        winner
      else
        card1 > card2 ? 0 : 1
      end
    if winner == 0
      decks.first << card1 << card2
    else
      decks.last << card2 << card1
    end
    return [0, decks.first] if decks.last.empty?
    return [1, decks.last] if decks.first.empty?
    round += 1
  end
  [0, decks.first]
end

def process(input)
  decks = input.split(/\n\n/).map { |deck| deck.split(/\n/)[1..-1].map(&:to_i) }
  _winner, winning_deck = recursion(decks)
  winning_deck.reverse.each_with_index.map { |card, index| card * (index + 1) }.sum
end

puts process(File.read('input'))
