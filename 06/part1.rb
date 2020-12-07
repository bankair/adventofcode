def parse(buffer)
  buffer.split(/^$/).map { |buffer| buffer.split(/\n/).map(&:chars) }
end

groups = parse(File.read('input'))

puts groups.map { |group| group.reduce(:+).uniq.count }.sum
