class Cup
  attr_accessor :value, :next_cup
  def initialize(value)
    self.value = value
  end

  def next_3
    [next_cup, next_cup.next_cup, next_cup.next_cup.next_cup]
  end

  def next_value(size)
    result = (value == 1 ? size : value - 1)
    next_3_values = next_3.map(&:value)
    while next_3_values.include?(result)
      result = (result == 1 ? size : result - 1)
    end
    result
  end
end

def build_index_and_circular_list(input, size)
  index = Array.new(size + 1)
  cursor = nil
  last_cup = nil
  input = input.chars.map(&:to_i)
  input += ((input.max + 1)..size).to_a
  input.each do |value|
    cup = Cup.new(value)
    cursor = cup unless cursor
    last_cup&.next_cup = cup
    last_cup = cup
    index[cup.value] = cup
  end
  last_cup.next_cup = cursor
  [index, cursor]
end

def move(cursor, index)
  next_cup = index[cursor.next_value(index.size - 1)]
  removed = cursor.next_3
  cursor.next_cup = removed.last.next_cup
  removed.last.next_cup = next_cup.next_cup
  next_cup.next_cup = removed.first
  cursor.next_cup
end

def process(input, size, moves)
  index, cursor = build_index_and_circular_list(input, size)
  moves.times { cursor = move(cursor, index) }
  cup = index[1]
  cup.next_cup.value * cup.next_cup.next_cup.value
end

puts process('685974213', 1_000_000, 10_000_000)
