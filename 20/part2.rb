require 'byebug'
require 'ostruct'

SEA_MONSTER = <<GRRRRWL
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
GRRRRWL

MONSTER_OFFSETS = [[-18, 1], [-13, 1], [-12, 1], [-7, 1], [-6, 1], [-1, 1], [0, 1], [1, 1], [-17, 2], [-14, 2], [-11, 2], [-8, 2], [-5, 2], [-2, 2]]

class Tile
  attr_accessor :id, :rows, :position
  def initialize(id, rows, position = nil)
    self.id = id
    self.rows = rows
    self.position = position
  end

  def self.build(buffer)
    lines = buffer.split(/\n/)
    new(lines[0][/\d+/].to_i, lines[1..-1].map(&:chars))
  end

  def borders
    @borders ||= borders_impl
  end

  def borders_impl
    transposed = rows.transpose
    OpenStruct.new(
      top: rows[0],
      bottom: rows[-1],
      left: transposed[0],
      right: transposed[-1],
    )
  end

  def match?(other)
    return [0, -1] if borders.top == other.borders.bottom
    return [0, 1] if borders.bottom == other.borders.top
    return [-1, 0] if borders.left == other.borders.right
    return [1, 0] if borders.right == other.borders.left
    nil
  end

  def rotate
    new_rows = rows.transpose
    Tile.new(id, new_rows.map(&:reverse), position)
  end

  def flip
    Tile.new(id, rows.map(&:reverse), position)
  end

  def self.test_rotations(tile1, tile2)
    result = tile1.match?(tile2)
    return [result, tile2] if result
    3.times do
      tile2 = tile2.rotate
      result = tile1.match?(tile2)
      return [result, tile2] if result
    end
    nil
  end

  def self.assemble(tile1, tile2)
    result = test_rotations(tile1, tile2)
    result = test_rotations(tile1, tile2.flip) unless result
    result
  end
end

def rebuild_map(tiles)
  candidates = [tiles.first]
  candidates.first.position = [0, 0]
  map = { candidates.first.position => candidates.first }
  matches = []
  remaining = tiles[1..-1]
  loop do
    break if candidates.empty?
    candidates.each do |current|
      remaining.each do |other|
        next if candidates.map(&:id).include?(other.id)
        offset, matched = Tile.assemble(current, other)
        next unless matched
        matched.position = current.position.zip(offset).map(&:sum)
        matches << matched
        map[matched.position] = matched
      end
      matches.each do |match|
        remaining.select! { |e| e.id != match.id }
      end
    end

    candidates = matches
    matches = []
  end
  map
end

def display_map(map)
  puts '-' * 80
  xs = map.keys.map(&:first)
  ys = map.keys.map(&:last)
  (ys.min..ys.max).each do |y|
    puts (xs.min..xs.max).map { |x| map[[x,y]]&.id || '????' }.join(' ')
  end
end

def rebuild_image(map)
  xs = map.keys.map(&:first)
  ys = map.keys.map(&:last)
  x_range = xs.min..xs.max
  y_range = ys.min..ys.max
  height = map.values.first.rows.first.size - 2
  result = Array.new(y_range.count * height) { [] }
  y_range.each_with_index do |y, i|
    x_range.each do |x|
      map[[x, y]].rows[1..-2].each_with_index do |row, j|
        result[i * height + j] += row[1..-2]
      end
    end
  end
  result
end

require 'set'

def check_monster(bitmap, x, y)
  return false if bitmap[y][x] == '.'
  MONSTER_OFFSETS.each do |offset|
    x_offset, y_offset = offset
    return false unless bitmap[y + y_offset]
    return false if bitmap[y + y_offset][x + x_offset] == '.'
  end
  true
end

def paint_monster(bitmap, x, y)
  bitmap[y][x] = 'M'
  MONSTER_OFFSETS.each do |offset|
    x_offset, y_offset = offset
    bitmap[y+y_offset][x+x_offset] = 'M'
  end
end

def paint_monsters(bitmap)
  bitmap.each_with_index do |row, y|
    row.each_with_index do |c, x|
      next if c == '.'
      paint_monster(bitmap, x, y) if check_monster(bitmap, x, y)
    end
  end
end

def process(input)
  tiles = input.split(/\n\n/).map { |str| Tile.build(str) }
  map = rebuild_map(tiles)
  bitmap = rebuild_image(map)
  paint_monsters(bitmap)
  3.times do
    bitmap = bitmap.transpose
    bitmap.map!(&:reverse)
    paint_monsters(bitmap)
  end
  bitmap.map!(&:reverse)
  paint_monsters(bitmap)
  3.times do
    bitmap = bitmap.transpose
    bitmap.map!(&:reverse)
    paint_monsters(bitmap)
  end
  puts bitmap.map{ |row| row.join }.join("\n")
  bitmap.map { |row| row.grep(/#/).count }.sum
end

puts process(File.read('input'))
