def process(input)
  joltages = input.split(/\n/).map(&:to_i).sort
  last = 0
  differences = { 1 => 0, 3 => 1 }
  joltages.each do |joltage|
    diff = joltage - last
    differences[diff] += 1
    last = joltage
  end
  differences.inspect
  differences[1] * differences[3]
end

puts process(File.read('input'))
