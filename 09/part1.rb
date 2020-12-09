def find_first_invalid(input, preamble_size = 25)
  numbers = input.split(/\n/).map(&:to_i)
  cursor = preamble_size
  loop do
    break if cursor >= numbers.count
    candidate = numbers[cursor]
    previous = numbers.slice(cursor - preamble_size, preamble_size)
    return candidate unless previous.combination(2).any? { |a, b| a != b && a + b == candidate }
    cursor += 1
  end
  raise 'not found'
end

puts find_first_invalid(File.read('input'))
