# frozen_string_literal: true

class Caves
  def initialize(rows)
    @rows = rows.map { |row| row.chars.map(&:to_i) }
  end

  def basins
    result = []
    @rows.each_with_index do |row, y|
      row.each_with_index do |_value, x|
        result << basin(x, y) if @rows[y][x] != 9
      end
    end
    result
  end

  def neighbors(x, y)
    yield [x - 1, y] if x.positive?
    yield [x + 1, y] if x < (@rows.first.size - 1)
    yield [x, y - 1] if y.positive?
    yield [x, y + 1] if y < (@rows.size - 1)
  end

  def basin(start_x, start_y)
    downhill = nil
    neighbors(start_x, start_y) do |x, y|
      downhill = [x, y] if @rows[start_y][start_x] > @rows[y][x]
    end
    downhill ? basin(*downhill) : [start_x, start_y]
  end
end

def process(input)
  caves = Caves.new(input.split(/\n/))
  caves.basins.group_by(&:itself).values.map(&:size).sort[-3..-1].reduce(&:*)
end

def test(input, expected)
  actual = process(input)
  if actual != expected
    puts "ERROR: #{actual.inspect} != #{expected}"
    puts "INPUT:\n#{input}"
    exit 1
  end
  puts "SUCCESS => #{actual.inspect}"
end

test(<<~TEST, 1134)
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
TEST

puts process(File.read('input'))
