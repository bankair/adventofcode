def seat_id(string)
  string.gsub(/[FL]/, '0').gsub(/[BR]/, '1').to_i(2)
end

seat_ids = File.readlines('input').map { |line| seat_id(line.chomp) }

puts seat_ids.max
