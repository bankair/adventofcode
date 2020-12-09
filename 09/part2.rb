def find_first_invalid(numbers, preamble_size)
  cursor = preamble_size
  loop do
    break if cursor >= numbers.count
    candidate = numbers[cursor]
    previous = numbers.slice(cursor - preamble_size, preamble_size)
    return [candidate, cursor] unless previous.combination(2).any? { |a, b| a != b && a + b == candidate }
    cursor += 1
  end
  raise 'not found'
end

def break_code(input, preamble_size = 25)
  numbers = input.split(/\n/).map(&:to_i)
  invalid_number, position = find_first_invalid(numbers, preamble_size)
  (0..(position - 2)).each do |a|
    (1..(position - 1)).each do |b|
      candidates = numbers[a..b]
      next unless candidates.sum == invalid_number
      return candidates.min + candidates.max
    end
  end
end

puts break_code(File.read('input'))
