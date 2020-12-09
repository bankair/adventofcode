require 'set'

class Program
  attr_accessor :instructions, :accumulator, :cursor, :operations
  def initialize(instructions)
    self.instructions = instructions
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
      return [:ok, accumulator] if cursor >= instructions.size
      return [:loop, accumulator] if visited.include?(cursor)
      visited << cursor
      instruction = instructions[cursor]
      op, arg = instruction.split(/ /)
      op = op.to_sym
      arg = Integer(arg)
      self.cursor = operations.fetch(op).(arg)
    end
  end
end

def run_corrected(instructions, line, index, source, target)
  new_instructions = instructions.clone
  corrected_instruction = line.gsub(/#{source}/, target)
  new_instructions[index] = corrected_instruction
  Program.new(new_instructions).run
end

def fix
  instructions = File.read('input').split(/\n/)
  instructions.each_with_index do |line, index|
    if line =~ /^jmp/
      status, accumulator = run_corrected(instructions, line, index, 'jmp', 'nop')
    elsif line =~ /^nop/
      status, accumulator = run_corrected(instructions, line, index, 'jmp', 'nop')
    else
      next
    end
    return accumulator if status == :ok
  end
end

puts fix
