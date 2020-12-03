class Map
  attr_reader :map, :width, :height

  def initialize(buffer)
    @map = buffer.split("\n")
    @width = map.first.size
    @height = map.size
  end


  def tree_count
    x, y = [0, 0]
    count = 0
    loop do
      break if y == height
      count += 1 if map[y][x] == '#'
      x = (x + 3) % width
      y += 1
    end
    count
  end

  def self.tree_count(buffer)
    Map.new(buffer).tree_count
  end
end

puts Map.tree_count(File.read('input'))

#puts Map.tree_count(<<MAP)
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
