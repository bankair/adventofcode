# frozen_string_literal: true

require 'byebug'

def process(input)
  puts "[#{Time.now}] Start"
  lines = input.split(/\n/)
  template = lines.shift.chars
  start = template
  rules = Hash[lines[1..-1].map { |line| line.split(/ -> /) }]
  pairs = pairs(template)
  40.times do
    new_pairs = {}
    pairs.each do |pair, count|
      prev, current = pair.chars
      insert = rules[prev + current]
      left = prev + insert
      right = insert + current
      new_pairs[left] = new_pairs[left].to_i + count
      new_pairs[right] = new_pairs[right].to_i + count
    end
    pairs = new_pairs
  end
  occurences = {}
  pairs.each do |pair, count|
    pair.chars.each { |c| occurences[c] = occurences[c].to_i + count }
  end
  occurences[start.first] += 1
  occurences[start.last] += 1
  occurences = occurences.sort_by(&:last)
  warn occurences.inspect
  (occurences.last.last - occurences.first.last) / 2
end

def pairs(template)
  prev = template.first
  result = []
  template[1..-1].each do |c|
    result << prev + c
    prev = c
  end
  result.group_by(&:itself).transform_values(&:count)
end

def iterate(template, rules)
    result = []
    previous = template.shift
    result << previous
    template.each do |current|
      insert = rules.fetch(previous + current)
      result += Array(insert)
      result << current
      previous = current
    end
    result
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

test(<<~TEST, 2188189693529)
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
TEST

puts process(File.read('input'))
