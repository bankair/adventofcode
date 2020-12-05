ROWS = 7.times.reduce(['']) { |roots, index| r = []; %w(F B).each { |c| roots.each { |prefix| r << prefix + c } }; r }.sort.reverse

def row(string)
  ROWS.index(string[0..6])
end

def column(string)
  %w[LLL LLR LRL LRR RLL RLR RRL RRR].index(string[-3..-1])
end

def seat_id(string)
  8 * row(string) + column(string)
end

seat_ids = File.readlines('input').map { |line| seat_id(line.chomp) }

min = seat_ids.min
max = seat_ids.max

my_seat = (min..max).to_a - seat_ids
puts my_seat.inspect
