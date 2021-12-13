# frozen_string_literal: true

require 'set'

def process(input)
  points, instructions = parse(input)
  instructions.each { |instruction| points = fold(points, *instruction) }
  dump(points)
end

def parse(input)
  input = input.split(/\n/)
  points = parse_points!(input)
  instructions = input.map do |line|
    axis, value = line[/.=\d+/].split('=')
    [axis.to_sym, value.to_i]
  end
  [Set.new(points), instructions]
end

def parse_points!(input)
  result = []
  loop do
    value = input.shift
    return result if value.empty?

    result << value.split(',').map(&:to_i)
  end
end

def fold(points, axis, value)
  axis == :x ? fold_x(points, value) : fold_y(points, value)
end

def dump(points)
  width = points.map(&:first).max
  result = []
  (0..points.map(&:last).max).each do
    result << ' ' * (1 + width)
  end
  points.each { |x, y| result[y][x] = '#' }
  result.join("\n")
end

def fold_x(points, value)
  Set.new(points.map { |x, y| [x > value ? value - (x - value) : x, y] })
end

def fold_y(points, value)
  Set.new(points.map { |x, y| [x, y > value ? value - (y - value) : y] })
end

def test(input, expected)
  actual = process(input)
  if actual != expected
    puts "ERROR: #{actual.inspect} != #{expected.inspect}"
    puts "INPUT:\n#{input}"
    exit 1
  end
  puts "SUCCESS => #{actual.inspect}"
end

expected = <<~EXPECTED
  #####
  #   #
  #   #
  #   #
  #####
EXPECTED

test(<<~TEST, expected.chomp)
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
TEST

puts process(File.read('input'))

