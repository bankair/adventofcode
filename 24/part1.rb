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

  def initialize(lobby, position)
    self.color = WHITE
    self.lobby = lobby
    self.position = position
  end

  def black?
    color == BLACK
  end

  def flip!
    self.color = color == WHITE ? BLACK : WHITE
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

  def origin
    tile(0, 0, 0)
  end

  def parse(line)
    cursor = origin
    loop do
      break if line.empty?
      prefix, offset = Tile::OFFSETS.find { |prefix, _offset| line.start_with?(prefix) }
      position = cursor.position.zip(offset).map(&:sum)
      cursor = tile(*position)
      line = String(line[prefix.size..-1])
    end
    cursor.flip!
  end
end


def process(input)
  lobby = Lobby.new
  input.split(/\n/).each { |line| lobby.parse(line) }
  lobby.tiles.values.select(&:black?).count
end

puts process(File.read('input'))
