require 'set'

def parse(buffer)
  result = Hash.new() { |hash, key| hash[key] = [] }
  buffer.split(/\n/).each do |line|
    parent, children_string = line[0..-2].split(/ bags contain /)
    next if children_string == 'no other bags'
    children_string.split(/, /).each do |child_string|
      count, pattern, color, _ = child_string.split(/ /)
      result[parent] << "#{pattern} #{color}"
    end
  end
  result
end

def find(rules, query = 'shiny gold')
  result = Set.new
  rules.each do |parent, children|
    next unless children.include?(query)
    result << parent
    result.merge(find(rules, parent))
  end
  result
end

puts find(parse(File.read('input'))).count
