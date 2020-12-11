def process(input)
  joltages = input.split(/\n/).map(&:to_i).sort

end

def process2(input)
  joltages = input.split(/\n/).map(&:to_i).sort
  rec_brut_force(0, joltages)
end

CACHE = {}

# Lame, as I'm sure there is a smart way to calculate this,
# but my brain is still sleeping, so let's do it like a bull.
def rec_brut_force(previous, joltages)
  return CACHE[[previous, joltages]] if CACHE[[previous, joltages]]
  return 1 if joltages.empty?
  result = 0
  result += rec_brut_force(joltages[0], joltages[1..-1]) if joltages[0] - previous <= 3
  result += rec_brut_force(joltages[1], joltages[2..-1]) if joltages[1] && joltages[1] - previous <= 3
  result += rec_brut_force(joltages[2], joltages[3..-1]) if joltages[2] && joltages[2] - previous <= 3
  CACHE[[previous, joltages]] = result
  result
end

puts process2(File.read('input')).inspect
