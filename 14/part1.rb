# frozen_string_literal: true

require 'byebug'

def process(input)
  lines = input.split(/\n/)
  template = lines.shift.chars
  rules = Hash[lines[1..-1].map { |line| line.split(/ -> /) }]
  10.times do
    new_template = []
    previous = template.shift
    new_template << previous
    template.each do |current|
      insert = rules.fetch(previous + current)
      new_template << insert << current
      previous = current
    end
    template = new_template
  end
  occurences = template.group_by(&:itself).map { |k,v| [k, v.count] }.sort_by(&:last)
  warn occurences.inspect
  occurences.last.last - occurences.first.last
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

test(<<~TEST, 1588)
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
