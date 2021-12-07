# frozen_string_literal: true

def process(input)
  crabs = Hash[input.split(/,/).map(&:to_i).group_by(&:itself)].transform_values(&:size)
  fuel = Float::INFINITY
  (crabs.keys.min..crabs.keys.max).each do |cursor|
    local_fuel = crabs.map do |pos, count|
      local_dist = (cursor - pos).abs
      (((local_dist + 1) * local_dist) / 2) * count
    end.sum
    fuel = local_fuel if local_fuel < fuel
  end
  fuel
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

test('16,1,2,0,4,2,7,1,2,14', 168)

puts process(File.read('input'))
