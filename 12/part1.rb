require 'byebug'
class Ferry
  NORTH = [0, 1]
  SOUTH = [0, -1]
  EAST = [1, 0]
  WEST = [-1, 0]
  DIRECTIONS = [EAST, SOUTH, WEST, NORTH]

  attr_accessor :direction_index, :position

  def initialize
    self.direction_index = 0
    self.position = [0, 0]
  end

  def move(direction, value)
    position.zip(direction.map { |e| e * value }).map(&:sum)
  end

  def operation(command)
    noop = ->(_value) { [direction_index, position] }
    (@operations ||= {
      N: ->(value) { [direction_index, move(NORTH, value)] },
      S: ->(value) { [direction_index, move(SOUTH, value)] },
      E: ->(value) { [direction_index, move(EAST, value)] },
      W: ->(value) { [direction_index, move(WEST, value)] },
      F: ->(value) { [direction_index, move(DIRECTIONS[direction_index], value)] },
      R: ->(value) { [(direction_index + value / 90) % 4, position] },
      L: ->(value) { [(direction_index - value / 90) % 4, position] },
    })[command.to_sym]
  end

  def process(instruction)
    inial_position = position.clone
    command = instruction[0]
    value = instruction[1..-1].to_i
    result = operation(command).(value)
    self.direction_index, self.position = result
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
