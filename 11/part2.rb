# frozen_string_literal: true

require 'byebug'
# Octopus
class Octopus
  attr_accessor :x, :y, :energy, :flashed, :count

  def initialize(energy, x, y)
    self.energy = Integer(energy)
    self.x = x
    self.y = y
    self.flashed = false
    self.count = 0
  end

  def flashed?
    flashed
  end

  def ready_to_flash?
    return false if flashed
    energy > 9
  end

  def increment!
    self.energy += 1
  end

  def flash!
    self.count += 1
    self.flashed = true
  end

  def reset!
    self.energy = 0 if self.energy > 9
    self.flashed = false
  end

  def to_s
    (energy > 9 ? 'F' : energy).to_s
  end
end

# Grid
class Grid
  attr_accessor :lines

  def initialize(lines)
    self.lines = lines.each_with_index.map do |line, y|
      line.chars.each_with_index.map { |c, x| Octopus.new(c, x, y) }
    end
  end

  def to_s
    lines.map { |line| line.map(&:to_s).join }.join("\n")
  end

  def each
    (0..9).each { |y| (0..9).each { |x| yield(lines[y][x]) } }
  end

  def count
    result = 0
    each do |octopus|
      result += octopus.count
    end
    result
  end

  def neighbors(octopus)
    (-1..1).each do |yoffset|
      line = lines[octopus.y + yoffset]
      next unless line && (octopus.y + yoffset) >= 0
      (-1..1).each do |xoffset|
        next if yoffset == xoffset && xoffset == 0
        neighbor = line[octopus.x + xoffset]
        yield(neighbor) if neighbor && (octopus.x + xoffset) >= 0
      end
    end
  end

  def iterate!
    each { |octopus| octopus.increment! }
    loop do
      stable = true
      lcount = 0
      each do |octopus|
        if octopus.ready_to_flash?
          octopus.flash!
          stable = false
          lcount += 1
          neighbors(octopus) { |neighbor| neighbor.increment! }
        end
      end
      break if stable
    end
    each { |octopus| octopus.reset! }
  end

  def all_flashed?
    each { |octopus| return false unless octopus.energy.zero? } 
  end
end

def process(input)
  grid = Grid.new(input.split(/\n/))
  i = 1 
  loop do
    grid.iterate!
    return i if grid.all_flashed?
    i += 1
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

test(<<~TEST, 195)
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
TEST

puts process(File.read('input'))
