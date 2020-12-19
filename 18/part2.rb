require 'byebug'

class State
  attr_accessor :output, :operators
  def initialize
    self.output = []
    self.operators = []
  end
end

OPERATORS = %w(+ *).freeze

def precedence?(operators)
  operators_top = operators.last
  return false unless OPERATORS.include?(operators_top.to_s)
  operators_top == :+
end

def process(line)
  state = State.new
  tokens = line.chars
  loop do
    break if tokens.empty?
    token = tokens.shift
    if token =~ /\d/
      state.output << token.to_i
    elsif OPERATORS.include?(token)
      while precedence?(state.operators)
        state.output << state.operators.pop
      end
      state.operators << token.to_sym
    elsif token == '('
      state.operators << '('
    elsif token == ')'
      while state.operators.last != '('
        state.output << state.operators.pop
      end
      state.operators.pop if state.operators.last == '('
    end
  end
  while !state.operators.empty?
    state.output << state.operators.pop
  end
  state
  stack = []
  state.output.each do |e|
    if [:+, :*].include?(e)
      a, b = stack.pop, stack.pop
      stack << a.send(e, b)
    else
      stack << e
    end
  end
  stack.first
end

def test(input, expected)
  actual = process(input)
  if actual != expected
    warn "Error: #{input} => #{actual.inspect} != #{expected.inspect}"
    exit(1)
  end
  puts "Success: #{input} => #{actual}"
end

test('1 + 2 * 3 + 4 * 5 + 6', 231)
test('1 + (2 * 3) + (4 * (5 + 6))', 51)
test('2 * 3 + (4 * 5)', 46)
test('5 + (8 * 3 + 9 + 3 * 4 * 3)', 1445)
test('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))', 669060)
test('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', 23340)

puts File.readlines('input').map { |line| process(line.chomp) }.sum
