# frozen_string_literal: true

def process(input) end

def test(input, expected)
  actual = process(input)
  if actual != expected
    puts "ERROR: #{actual.inspect} != #{expected}"
    puts "INPUT:\n#{input}"
    exit 1
  end
  puts "SUCCESS => #{actual.inspect}"
end

test(<<~TEST, :replace_me_by_expected_result)
  My test input
TEST

puts process(File.read('input'))
