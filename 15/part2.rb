# frozen_string_literal: true

require 'pqueue'
require 'set'

def neighbors(x, y, width, height)
  yield([x - 1, y]) if x.positive?
  yield([x + 1, y]) if x < width - 1
  yield([x, y - 1]) if y.positive?
  yield([x, y + 1]) if y < height - 1
end

def process(input)
  input = input.split(/\n/).map { |line| line.chars.map(&:to_i) }
  grid = 5.times.flat_map do |ny|
    input.map { |row| 5.times.flat_map { |nx| row.map { |risk| (risk + ny + nx - 1) % 9 + 1 } } }
  end
  target = [grid[0].size - 1, grid.size - 1]
  visited = Set[]
  queue = PQueue.new([[[0, 0], 0]]) { |a, b| a.last < b.last }
  until queue.empty?
    node, risk = queue.pop
    next unless visited.add?(node)
    return risk if node == target

    neighbors(*node, grid.first.size, grid.size) { |x, y| queue.push([[x,y], risk + grid[y][x]]) }
  end
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

test(<<~TEST, 315)
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
