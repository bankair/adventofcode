require 'byebug'

class Cube < String
  ACTIVE = Cube.new('#')
  INACTIVE = Cube.new('.')

  def active?
    self == ACTIVE
  end
end

class PocketDimension
  attr_accessor :cubes

  def self.new_cubes_container
    Hash.new { Cube::INACTIVE }
  end

  def self.build(input)
    cubes = new_cubes_container
    input.split(/\n/).each_with_index do |line, x|
      line.chars.each_with_index do |char, y|
        cubes[[x, y, 0]] = Cube.new(char)
      end
    end
    PocketDimension.new(cubes)
  end

  def initialize(cubes)
    self.cubes = cubes
  end

  OFFSETS = [-1, 0, 1]
  IDENTITY = [0, 0, 0]

  def self.offsets
    return @offsets if @offsets
    results = []
    OFFSETS.each do |x|
      OFFSETS.each do |y|
        OFFSETS.each do |z|
          candidate = [x, y, z]
          results << candidate unless candidate == IDENTITY
        end
      end
    end
    @offsets = results
  end

  def offsets
    self.class.offsets
  end

  def position_range
    return [[0, 0, 0,], [0, 0, 0]] if cubes.empty?
    positions = cubes.keys
    mins = positions.first
    maxes = positions.first
    positions.each do |position|
      mins = mins.zip(position).map(&:min)
      maxes = maxes.zip(position).map(&:max)
    end
    [mins, maxes]
  end

  def next_cube(position, current = cube(*position))
    actives = offsets.map { |offset| offset.zip(position).map(&:sum) }.select do |other_pos|
      cube(*other_pos).active?
    end
    return Cube::ACTIVE if actives.count == 3
    return Cube::ACTIVE if current.active? && actives.count == 2
    Cube::INACTIVE
  end

  def cycle
    new_cubes = self.class.new_cubes_container
    mins, maxes = position_range
    mins.map! { |v| v - 1 }
    maxes.map! { |v| v + 1 }
    (mins[0]..maxes[0]).each do |x|
      (mins[1]..maxes[1]).each do |y|
        (mins[2]..maxes[2]).each do |z|
          position = [x, y, z]
          value = next_cube(position)
          new_cubes[position] = value if value.active?
        end
      end
    end
    PocketDimension.new(new_cubes)
  end

  def active_cubes
    cubes.values.select(&:active?)
  end

  def cube(x, y, z)
    cubes[[x, y, z]]
  end

  def to_s
    result = 'V' * 80 + "\n"
    mins, maxes = position_range
    (mins.last..maxes.last).each do |z|
      result += "z=#{z}\n"
      (mins[0]..maxes[0]).each do |x|
        (mins[1]..maxes[1]).each do |y|
          result += cube(x, y, z)
        end
        result += "\n"
      end
      result += "\n"
    end
    result += 'A' * 80 + "\n"
    result
  end
end

def process(input, cycles = 6)
  dimension = PocketDimension.build(input)
  cycles.times do
    dimension = dimension.cycle
  end
  dimension.active_cubes.count
end

puts process(File.read('input'))
