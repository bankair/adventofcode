class Map
  attr_reader :map, :width, :height

  def initialize(buffer)
    @map = buffer.split("\n")
    @width = map.first.size
    @height = map.size
  end


  def tree_count(x_offset, y_offset)
    x, y = [0, 0]
    count = 0
    loop do
      break if y >= height
      count += 1 if map[y][x] == '#'
      x = (x + x_offset) % width
      y += y_offset
    end
    count
  end

  def self.tree_counts(buffer)
    map = Map.new(buffer)
    [
      [1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2],
    ].map { |x_offset, y_offset| map.tree_count(x_offset, y_offset) }.reduce(:*)
  end
end

puts Map.tree_counts(File.read('input'))

#puts Map.tree_counts(<<MAP)
#..##.......
##...#...#..
#.#....#..#.
#..#.#...#.#
#.#...##..#.
#..#.##.....
#.#.#.#....#
#.#........#
##.##...#...
##...##....#
#.#..#...#.#
#MAP
