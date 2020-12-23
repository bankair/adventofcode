def position(cups)
  target = cups.first
  target += (target == 1 ? cups.size - 1 : -1) while cups[0..3].include?(target)
  cups.index(target)
end

def move(cups)
  new_position = position(cups)
  cups[4..new_position] + cups[1..3] + cups[new_position + 1..-1] + [cups.first]
end

def process(input, moves)
  cups = moves.times.reduce(input.chars.map(&:to_i)) { |acc| move(acc) }
  cups.rotate(cups.index(1))[1..-1].join
end

puts process('685974213', 100)
