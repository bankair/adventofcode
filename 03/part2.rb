# frozen_string_literal: true

def process(input)
  numbers = input.split(/\n/).map(&:chars)
  o2 = find(:most, numbers).join.to_i(2)
  co2 = find(:least, numbers).join.to_i(2)
  o2 * co2
end

def find(common, numbers, offset = 0)
  bit = find_bit(common, numbers, offset).to_s
  numbers = numbers.select { |e| e[offset] == bit }
  numbers.size == 1 ? numbers.first : find(common, numbers, offset + 1)
end

def find_bit(common, numbers, offset)
  bit = (numbers.map { |a| a[offset] }.count('1').to_f / numbers.size).round
  common == :least ? (bit + 1) % 2 : bit
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

test(<<~TEST, 230)
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
