require 'byebug'

class State
  attr_accessor :op, :value
  def initialize
    self.op = :+
    self.value = 0
  end

  def operation(other)
    value.send(op, other)
  end
end

def process(line)
  stack = []
  state = State.new
  line.chars.each do |c|
    if c =~ /\d/
      state.value = state.operation(c.to_i)
    elsif %w(+ *).include?(c)
      state.op = c.to_sym
    elsif c == '('
      stack << state
      state = State.new
    elsif c == ')'
      current_value = state.value
      state = stack.pop
      state.value = state.operation(current_value)
    end
  end
  state.value
end

def test(input, expected)
  actual = process(input)
  if actual != expected
    warn "Error: #{input} => #{actual.inspect} != #{expected.inspect}"
    exit(1)
  end
  puts "Success: #{input} => #{actual}"
end

test('1 + 2 * 3 + 4 * 5 + 6', 71)
test('1 + (2 * 3) + (4 * (5 + 6))', 51)
test('2 * 3 + (4 * 5)', 26)
test('5 + (8 * 3 + 9 + 3 * 4 * 3)', 437)
test('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))', 12240)
test('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', 13632)

puts File.readlines('input').map { |line| process(line.chomp) }.sum
