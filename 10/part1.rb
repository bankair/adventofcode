# frozen_string_literal: true

SCORES = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }.freeze

def process(input)
  lines = input.split(/\n/)
  score = 0
  lines.each do |line|
    stack = []
    line.chars.each do |c|
      if '({[<'.index(c)
        stack << c
      else
        if { '(' => ')', '{' => '}', '[' => ']', '<' => '>' }[stack.pop] != c
          score += SCORES[c]
          break
        end
      end
    end
  end
  score
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

test(<<~TEST, 26397)
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
TEST

puts process(File.read('input'))
