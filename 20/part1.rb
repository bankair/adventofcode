require 'byebug'

class Border
  attr_accessor :chars
  def initialize(chars)
    self.chars = chars
  end

  def match?(other)
    string = chars.join
    other_string = other.chars.join
    string == other_string || string.reverse == other_string
  end
end

class Tile
  attr_accessor :id, :rows
  def initialize(buffer)
    lines = buffer.split(/\n/)
    self.id = lines[0][/\d+/].to_i
    self.rows = lines[1..-1].map(&:chars)
  end

  def borders
    transposed = rows.transpose
    [
      Border.new(rows[0]),
      Border.new(rows[-1]),
      Border.new(transposed[0]),
      Border.new(transposed[-1]),
    ]
  end

  def match?(other_border)
    borders.any? { |border| border.match?(other_border) }
  end
end

def process(input)
  tiles = input.split(/\n\n/).map { |str| Tile.new(str) }
  matches_hash = Hash[
    tiles.map do |tile|
      matches = 0
      tiles.each do |other|
        next if other.id == tile.id
        matches += 1 if tile.borders.any? { |border| other.match?(border) }
      end
      [tile.id, matches]
    end
  ]
  matches_hash.select { |id, count| count == 2 }.keys.reduce(:*)
end

puts process(File.read('input'))
