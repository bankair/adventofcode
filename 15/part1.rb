# frozen_string_literal: true

require 'set'

Node = Struct.new(:x, :y, :cost)

def process(input)
  unvisited = Set.new
  dist = {}
  costs = {}
  lines = input.split(/\n/)
  height = lines.count
  width = lines.first.size
  nodes = []
  lines.each_with_index do |line, y|
    nodes << []
    line.chars.each_with_index do |cost, x|
      node = Node.new(x, y, cost.to_i)
      nodes.last << node
      unvisited << node
      dist[node] = Float::INFINITY
    end
  end
  current = unvisited.find { |node| node.x.zero? && node.y.zero? }
  dist[current] = 0
  loop do
    ldist = dist[current]
    neighbors(current, width, height) do |x, y|
      neighbor = nodes[y][x]
      if unvisited.include?(neighbor)
        tentative_dist = ldist + neighbor.cost
        dist[neighbor] = tentative_dist if tentative_dist < dist[neighbor]
      end
    end
    unvisited.delete(current)
    return dist[current] if current.x == width - 1 && current.y == height - 1

    current = unvisited.to_a.sort_by { |node| dist[node] }.first
  end
end

def neighbors(node, width, height)
  yield([node.x - 1, node.y]) if node.x.positive?
  yield([node.x + 1, node.y]) if node.x < width - 1
  yield([node.x, node.y - 1]) if node.y.positive?
  yield([node.x, node.y + 1]) if node.y < height - 1
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

test(<<~TEST, 40)
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
TEST

puts process(File.read('input'))
