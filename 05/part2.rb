# frozen_string_literal: true

require 'byebug'

def process(input)
  min_x = Float::INFINITY
  min_y = Float::INFINITY
  max_x = 0
  max_y = 0
  segments = []
  input.split(/\n/).each do |line|
    x1, y1, x2, y2 = line.split(' -> ').map { |pos| pos.split(/,/) }.reduce(&:+).map(&:to_i)
    segments << [x1, y1, x2, y2]
    min_x = x1 if x1 < min_x
    min_x = x2 if x2 < min_x
    min_y = y1 if y1 < min_y
    min_y = y2 if y2 < min_y
    max_x = x1 if x1 > max_x
    max_x = x2 if x2 > max_x
    max_y = y1 if y1 > max_y
    max_y = y2 if y2 > max_y
  end
  result = 0
  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      segments_count = 0
      segments.each do |segment|
        segments_count += 1 if on_segment?(x, y, segment)
        break if segments_count > 1
      end
      result += 1 if segments_count > 1
    end
  end
  result
end

def on_segment?(x, y, segment)
  x1, y1, x2, y2 = segment
  crossproduct = (y - y1) * (x2 - x1) - (x - x1) * (y2 - y1)

  return false unless crossproduct.abs.zero?

  dotproduct = (x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)
  return false if dotproduct.negative?

  squaredlengthba = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
  return false if dotproduct > squaredlengthba

  true
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

test(<<~TEST, 12)
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
TEST

puts process(File.read('input'))
