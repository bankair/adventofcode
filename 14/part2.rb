require 'byebug'

def fetch_address(target, add_mask)
  address = target[/\d+/].to_i
  address | add_mask
end

def process(input)
  memory = {}
  add_mask = nil
  floating_bits = []
  input.split(/\n/).each do |line|
    if line.match?(/^mask = /)
      str_mask = line.split(/ = /).last
      add_mask = str_mask.gsub(/[X]/, '0').to_i(2)
      floating_bits = str_mask.enum_for(:scan, /X/).map { 35 - Regexp.last_match.offset(0).first }
    elsif line.match?(/^mem/)
      target, value = line.split(/ = /)
      value = value.to_i
      addresses = [fetch_address(target, add_mask)]
      floating_bits.each do |index|
        new_adresses = []
        addresses.each do |address|
          offset = 2 ** index
          new_adresses << (address | offset)
          new_adresses << ((address | offset) - offset)
        end
        addresses = new_adresses
      end
      addresses.each { |address| memory[address] = value }
    else
      raise :patate
    end
  end
  memory.values.sum
end


# puts process(<<TEST)
# mask = 000000000000000000000000000000X1001X
# mem[42] = 100
# mask = 00000000000000000000000000000000X0XX
# mem[26] = 1
# TEST

puts process(File.read('input'))
