def parse(buffer)
  buffer.split(/\n\n/).map { |buffer| buffer.split(/\n/).map(&:chars) }
end


def count(groups)
  groups.map { |group| group.reduce(:&).count }.sum
end

puts(count(parse(File.read('input'))))
