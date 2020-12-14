require 'byebug'
class Ferry
  NORTH = [0, 1]
  SOUTH = [0, -1]
  EAST = [1, 0]
  WEST = [-1, 0]
  DIRECTIONS = [EAST, SOUTH, WEST, NORTH]

  attr_accessor :direction_index, :position, :waypoint

  def initialize
    self.position = [0, 0]
    self.waypoint = [10, 1]
  end

  def move(point, waypoint, value)
    point.zip(waypoint.map { |e| e * value }).map(&:sum)
  end

  def rotate(point, value)
    result = point.clone
    rotations = (value / 90) % 4
    rotations = 4 + rotations if rotations < 0
    rotations.times { result = [result.last, -result.first] }
    result
  end

  def operation(command)
    noop = ->(_value) { [waypoint, position] }
    (@operations ||= {
      N: ->(value) { [move(waypoint, NORTH, value), position] },
      S: ->(value) { [move(waypoint, SOUTH, value), position] },
      E: ->(value) { [move(waypoint, EAST, value), position] },
      W: ->(value) { [move(waypoint, WEST, value), position] },
      F: ->(value) { [waypoint, move(position, waypoint, value)] },
      R: ->(value) { [rotate(waypoint, value), position] },
      L: ->(value) { [rotate(waypoint, -value), position] },
    })[command.to_sym]
  end

  def process(instruction)
    inial_position = position.clone
    command = instruction[0]
    value = instruction[1..-1].to_i
    result = operation(command).(value)
    self.waypoint, self.position = result
  end

  def distance
    position[0].abs + position[1].abs
  end
end

def process(input)
  ferry = Ferry.new
  input.split(/\n/).each { |line| ferry.process(line) }
  ferry.distance
end

# puts process(<<TEST)
# F10
# N3
# F7
# R90
# F11
# TEST

puts process(File.read('input'))
