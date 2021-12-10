# frozen_string_literal: true

class Caves
  def initialize(rows)
    @rows = rows.map { |row| row.chars.map(&:to_i) }
  end

  def low_points
    result = []
    @rows.each_with_index do |row, y|
      row.each_with_index do |value, x|
        next if x.positive? && row[x - 1] <= value
        next if x < (row.size - 1) && row[x + 1] <= value
        next if y.positive? && @rows[y - 1][x] <= value
        next if y < (@rows.size - 1) && @rows[y + 1][x] <= value

        result << value
      end
    end
    result
  end

  def risk_level
    low_points.count + low_points.sum
  end
end

def process(input)
  caves = Caves.new(input.split(/\n/))
  caves.risk_level
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

test(<<~TEST, 15)
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
TEST

puts process(File.read('input'))
