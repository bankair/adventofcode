def seat_id(string)
  string.gsub(/[FL]/, '0').gsub(/[BR]/, '1').to_i(2)
end

seat_ids = File.readlines('input').map { |line| seat_id(line.chomp) }

min = seat_ids.min
max = seat_ids.max

my_seat = (min..max).to_a - seat_ids
puts my_seat.inspect
