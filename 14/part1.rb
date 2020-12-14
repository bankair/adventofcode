require 'byebug'

def process(input)
  memory = {}
  add_mask = nil
  sub_mask = nil
  input.split(/\n/).each do |line|
    if line.match?(/^mask = /)
      str_mask = line.split(/ = /).last
      add_mask = str_mask.gsub(/[X]/, '0').to_i(2)
      sub_mask = str_mask.gsub(/[X]/, '1').to_i(2)
    elsif line.match?(/^mem/)
      target, value = line.split(/ = /)
      value = value.to_i
      value = value & sub_mask
      value = value | add_mask
      memory[target[/\d+/].to_i] = value
    else
      raise :patate
    end
  end
  memory.values.sum
end


# puts process(<<TEST)
# mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
# mem[8] = 11
# mem[7] = 101
# mem[8] = 0
# TEST

puts process(File.read('input'))
