require 'byebug'
class WaitingArea
  attr_accessor :matrix
  def initialize(matrix)
    self.matrix = matrix.clone
    self.matrix.map!(&:clone)
  end

  def seat?(value)
    value != '.'
  end

  def occupied?(value)
    value == '#'
  end

  def each_seat
    raise 'Missing block' unless block_given?
    matrix.each_with_index do |row, x|
      row.each_with_index do |value, y|
        yield(value, x, y) if seat?(value)
      end
    end
  end

  def seats_count
    total = 0
    each_seat { |seat, x, y| total += 1 if occupied?(seat) }
    total
  end

  def equals(other)
    matrix.zip(other.matrix).all? { |self_row, other_row| self_row == other_row }
  end

  OFFSETS = [-1, 0, 1].freeze

  def each_adjacent_seats(x, y, debug=false)
    raise 'Missing block' unless block_given?
    OFFSETS.each do |x_offset|
      next if x + x_offset < 0
      row = matrix[x + x_offset]
      next unless row
      OFFSETS.each do |y_offset|
        next if y + y_offset < 0
        next if x_offset == 0 && y_offset == 0
        seat = row[y + y_offset]
        yield(seat) if seat?(seat)
      end
    end
  end

  def next_seat(x, y, value)
    if value == 'L'
      each_adjacent_seats(x, y) do |seat|
        return 'L' if occupied?(seat)
      end
      '#'
    elsif value == '#'
      occupied_adjacent_seats = 0
      each_adjacent_seats(x, y) { |seat| occupied_adjacent_seats += 1 if occupied?(seat) }
      occupied_adjacent_seats >= 4 ? 'L' : '#'
    else
      raise 'Universe breached'
    end
  end

  def next_generation
    result = WaitingArea.new(matrix)
    each_seat { |seat, x, y| result.matrix[x][y] = next_seat(x, y, seat) }
    result
  end
end

def process(input)
  lines = input.split(/\n/)
  waiting_area = WaitingArea.new(lines.map(&:chars))
  loop do
    next_waiting_area = waiting_area.next_generation
    return waiting_area.seats_count if next_waiting_area.equals(waiting_area)
    waiting_area = next_waiting_area
  end
end

puts process(File.read('input'))
