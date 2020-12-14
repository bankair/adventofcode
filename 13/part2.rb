# Keeping this for posterity
# def euclid(a, b)
#   r, u, v, rp, up, vp = [a, 1, 0, b, 0, 1]
#   r = a
#   u = 1
#   v = 0
#   rp = b
#   up = 0
#   vp = 1
#   loop do
#     return v if rp == 0
#     q = r / rp
#     r, u, v, rp, up, vp = [rp, up, vp, r - q * rp, u - q * up, v - q * vp]
#   end
# end
# def chinese_remainder(mods, remainders)
#   puts mods.zip(remainders).inspect
#   n = mods.reduce(:*)
#   nis = mods.map { |ni| n / ni }
#   eis = nis.zip(mods).map { |a, b| euclid(b, a) * a }
#   remainders.zip(eis).map { |e| e.reduce(:*) }.sum % n
# end

def process(input)
  buses = input.split(/\n/).last.chomp.split(/,/)
    .each_with_index
    .reject { |id, i| id == 'x' }
    .each { |array| array.map!(&:to_i) }
  # Fuck it, doesn't work...
  # chinese_remainder(mods, remainders)
  period, offset = buses.first
  buses[1..-1].each do |bus, bus_offset|
    n = 0
    loop do
      break if (n * period + offset + bus_offset) % bus == 0
      n += 1
    end
    offset = offset + n * period
    period = period * bus
  end
  offset
end

# puts process('3,x,x,4,5')
# puts process('67,7,59,61')
# puts process('7,13,x,x,59,x,31,19')

puts process(File.read('input'))
