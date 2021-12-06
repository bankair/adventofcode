# frozen_string_literal: true

def process(input)
  fishes = Hash.new(0)
  input.split(/,/).each { |fish| fishes[fish.to_i] += 1 }
  256.times do
    next_day = Hash.new(0)
    fishes.each do |age, number|
      if age.zero?
        next_day[8] += number
        next_day[6] += number
      else
        next_day[age - 1] += number
      end
    end
    fishes = next_day
  end
  fishes.values.sum
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

test('3,4,3,1,2', 26_984_457_539)
puts process(File.read('input'))
