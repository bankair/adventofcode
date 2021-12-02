# frozen_string_literal: true

ACTIONS = {
  'forward' => ->(x, y, value) { [x + value, y] },
  'up' => ->(x, y, value) { [x, y - value] },
  'down' => ->(x, y, value) { [x, y + value] }
}.freeze

def process(input)
  x = y = 0
  input.split(/\n/).each do |e|
    action, value = e.split
    x, y = ACTIONS.fetch(action).call(x, y, value.to_i)
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

test(<<~TEST, 150)
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
TEST

puts process(File.read('input'))
