require 'set'

class BagRule
  attr_reader :count, :color
  def initialize(count, color)
    @count = count.to_i
    @color = color
  end
end


def parse(buffer)
  result = Hash.new() { |hash, key| hash[key] = [] }
  buffer.split(/\n/).each do |line|
    parent, children_string = line[0..-2].split(/ bags contain /)
    next if children_string == 'no other bags'
    children_string.split(/, /).each do |child_string|
      count, pattern, hue, _ = child_string.split(/ /)
      result[parent] << BagRule.new(count, pattern + ' ' + hue)
    end
  end
  result
end

def find(rules, query = 'shiny gold', depth = 1)
  children = rules[query]
  puts "#{'  ' * depth} #{query} => #{children.inspect}"
  return 1 if children.empty?
  children.map do |child|
    find(rules, child.color, depth + 1) * child.count
  end.sum + 1
end

puts find(parse(File.read('input'))) - 1
