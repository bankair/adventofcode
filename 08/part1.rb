require 'set'

class Program
  attr_accessor :instructions, :accumulator, :cursor, :operations
  def initialize(buffer)
    self.instructions = buffer.split(/\n/)
    self.operations = {
      acc: -> (arg) { self.accumulator += arg; self.cursor + 1 },
      jmp: -> (arg) { self.cursor + arg },
      nop: -> (_arg) { self.cursor + 1 },
    }
  end


  def run
    visited = Set.new
    self.accumulator = 0
    self.cursor = 0
    loop do
      break if cursor >= instructions.size
      return accumulator if visited.include?(cursor)
      visited << cursor
      instruction = instructions[cursor]
      op, arg = instruction.split(/ /)
      op = op.to_sym
      arg = Integer(arg)
      self.cursor = operations.fetch(op).(arg)
    end
    self.accumulator
  end
end

puts Program.new(File.read('input')).run
