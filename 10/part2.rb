# frozen_string_literal: true

SCORES = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }.freeze

def line_score(line)
  stack = []
  line.chars.each do |c|
    if '({[<'.index(c)
      stack << c
    elsif { '(' => ')', '{' => '}', '[' => ']', '<' => '>' }[stack.pop] != c
      return
    end
  end
  score = 0
  stack.reverse.map { |c| SCORES[c] }.each do |char_score|
    score = score * 5 + char_score
  end
  score
end

def process(input)
  lines = input.split(/\n/)
  scores = []
  lines.each do |line|
    score = line_score(line)
    scores << score if score
  end
  scores.sort[scores.size / 2]
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

test(<<~TEST, 288957)
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
