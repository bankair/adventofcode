require 'byebug'

ITERATIONS = 2020

def process(input)
  numbers = input.split(/,/).map(&:to_i)
  hash = Hash[numbers[0..-2].each_with_index.to_a.map { |a, b| [a, b + 1] }]
  count = hash.size
  number = numbers.last
  loop do
    return number if count == ITERATIONS - 1
    count += 1
    if hash[number]
      new_number = count - hash[number]
      hash[number] = count
      number = new_number
    else
      hash[number] = count
      number = 0
    end
  end
end

puts "Final result: #{process('0,1,4,13,15,12,16')}"
