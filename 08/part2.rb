# frozen_string_literal: true

require 'set'

#  1
# 6 2
#  7
# 5 3
#  4

NUMBERS = [
  [1, 2, 3, 4, 5, 6],
  [2, 3],
  [1, 2, 7, 5, 4],
  [1, 2, 7, 3, 4],
  [2, 3, 7, 6],
  [1, 6, 7, 3, 4],
  [1, 3, 4, 5, 6, 7],
  [1, 2, 3],
  [1, 2, 3, 4, 5, 6, 7],
  [1, 2, 3, 4, 6, 7]
].freeze

CHAR_RANGE = ('a'..'g').freeze

def assign!(leds, indices, value_set)
  indices = Array(indices).map { |e| e - 1 }
  leds.each_with_index { |set, index| value_set.each { |value| set.delete(value) } unless indices.include?(index) }
  indices.each { |index| leds[index] = leds[index] & value_set }
end

def process(input)
  input.split(/\n/).map! do |line|
    leds = 7.times.map { (CHAR_RANGE).to_a.to_set }
    patterns, output = line.split(' | ').map { |digits| digits.split.map(&:chars) }
    one, seven, four = [2, 3, 4].map { |size| patterns.find { |e| e.size == size }.to_set }
    { 1 => one, 7 => seven, 4 => four }.each { |value, set| assign!(leds, NUMBERS[value], set) }
    assign!(leds, 1, seven - one)
    CHAR_RANGE.each do |char|
      count = patterns.count { |p| p.include?(char) }
      index = { 9 => 3, 4 => 5, 6 => 6 }[count]
      assign!(leds, index, Set.new([char])) if index
    end
    output.map { |word| NUMBERS.index { |array| array.sort == word.map { |char| leds.index(Set.new([char])) + 1 }.sort } }.map(&:to_s).join.to_i
  end.sum
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

test(<<~TEST, 61229)
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
TEST

puts process(File.read('input'))
