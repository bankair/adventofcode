class Tile
  WHITE = 0
  BLACK = 1

  attr_accessor :lobby, :position, :color

  OFFSETS = [
    ['sw', [-1, 0, 1]],
    ['se', [0, -1, 1]],
    ['nw', [0, 1, -1]],
    ['ne', [1, 0, -1]],
    ['e', [1, -1, 0]],
    ['w', [-1, 1, 0]]
  ].freeze
  NEIGHBORS_OFFSETS = OFFSETS.map(&:last)


  def initialize(lobby, position, color = WHITE)
    self.color = color
    self.lobby = lobby
    self.position = position
  end

  def black?
    color == BLACK
  end

  def flip!
    self.color = color == WHITE ? BLACK : WHITE
  end

  def neighbors
    @neighbors ||= NEIGHBORS_OFFSETS.map { |offset| lobby.tile(*position.zip(offset).map(&:sum)) }
  end
end

class Lobby
  attr_accessor :tiles

  def initialize
    self.tiles = Hash.new { |hash, position| hash[position] = Tile.new(self, position) }
  end

  def tile(x, y, z)
    tiles[[x,y,z]]
  end

  def parse(line)
    cursor = tile(0, 0, 0)
    loop do
      break if line.empty?
      prefix, offset = Tile::OFFSETS.find { |prefix, _offset| line.start_with?(prefix) }
      position = cursor.position.zip(offset).map(&:sum)
      cursor = tile(*position)
      line = String(line[prefix.size..-1])
    end
    cursor.flip!
  end

  def each_tile
    uniq_tiles = {}
    tiles.values.each do |tile|
      next unless tile.black?
      uniq_tiles[tile.position] = tile
      tile.neighbors.each { |neighbor| uniq_tiles[neighbor.position] = neighbor }
    end
    uniq_tiles.values.each { |tile| yield tile }
  end

  def art_the_shit_out_of_it!
    tiles_to_flip = []
    each_tile do |tile|
      surrounding_black_tiles = tile.neighbors.select(&:black?).count
      next if tile.black? ? (1..2).include?(surrounding_black_tiles) : surrounding_black_tiles != 2
      tiles_to_flip << tile
    end
    tiles_to_flip.each(&:flip!)
  end
end

def initial_installation(input)
  lobby = Lobby.new
  input.split(/\n/).each { |line| lobby.parse(line) }
  lobby
end

def process(input)
  lobby = initial_installation(input)
  100.times { |i| lobby.art_the_shit_out_of_it! }
  lobby.tiles.values.select(&:black?).count
end

puts process(File.read('input'))
