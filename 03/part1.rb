# frozen_string_literal: true

def process(input)
  numbers = input.split(/\n/).map(&:chars)
  array = numbers.first.size.times.map { |i| numbers.map { |b| b[i] }.count('1') }
  gamma = array.map { |count| (count.to_f / numbers.size).round.to_s }.join.to_i(2)
  epsilon = array.map { |count| ((numbers.size - count).to_f / numbers.size).round.to_s }.join.to_i(2)
  gamma * epsilon
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

test(<<~TEST, 198)
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
TEST

puts process(File.read('input'))
