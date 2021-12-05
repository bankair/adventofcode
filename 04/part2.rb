# frozen_string_literal: true

class Cell
  attr_accessor :value, :marked
  def initialize(value)
    self.value = value
  end

  def mark!
    self.marked = true
  end

  def score
    marked ? 0 : value
  end

  def to_s
    marked ? "X" : value
  end
end

class Board
  def initialize(lines)
    @lines = lines.map { |line| line.map { |value| Cell.new(value) } }
  end

  def mark!(value)
    result = false
    @lines.each do |line|
      line.each do |cell|
        next if cell.marked
        if cell.value == value
          result = cell.mark!
          result = true
        end
      end
    end
    result
  end

  def winning?
    cols = @lines.first.size.times.map { true }
    @lines.each do |line|
      marked = line.map(&:marked)
      return true if marked.all?
      cols = cols.zip(marked).map { |a, b| a && b }
    end
    cols.any?
  end

  def score
    @lines.map { |line| line.map(&:score).sum }.sum
  end

  def to_s
    @lines.map { |line| line.map(&:to_s).join(' ') }.join("\n")
  end
end

def game_loop(boards, numbers)
  loop do
    value = numbers.shift
    boards.each do |board|

      marked = board.mark!(value)
       if marked && board.winning?
         return [value, board] if boards.size == 1
       end
    end
    boards.reject!(&:winning?)
  end
end
require 'byebug'
def process(input)
  input = input.split(/\n\n/)
  numbers = input.first.split(/,/).map(&:to_i)
  boards = input[1..-1].map { |lines| Board.new(lines.split(/\n/).map { |line| line.lstrip.split(/ +/).map(&:to_i) }) }
  winning_value, winning_board = game_loop(boards, numbers)
  warn(winning_board.to_s)
  warn winning_value
  winning_board.score * winning_value
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

test(<<~TEST, 1924)
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
TEST

puts process(File.read('input'))
