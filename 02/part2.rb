# frozen_string_literal: true

ACTIONS = {
  'forward' => ->(x, y, aim, value) { [x + value, y + value * aim, aim] },
  'up' => ->(x, y, aim, value) { [x, y, aim - value] },
  'down' => ->(x, y, aim, value) { [x, y, aim + value] }
}.freeze

def process(input)
  x = y = aim = 0
  input.split(/\n/).each do |e|
    action, value = e.split
    x, y, aim = ACTIONS.fetch(action).call(x, y, aim, value.to_i)
  end
  x * y
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

test(<<~TEST, 900)
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
TEST

puts process(File.read('input'))
