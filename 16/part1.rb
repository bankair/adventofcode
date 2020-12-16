def process(input)
  ranges, my_ticket, nearby_tickets = input.split(/\n\n/).map(&:chomp)
  ranges = Hash[
    ranges.split(/\n/).map do |line|
      key, rules =  line.split(/: /)
      [key, rules.split(/ or /).map { |str| values = str.split(/-/).map(&:to_i); values.first..values.last }]
    end
  ]
  my_ticket = my_ticket.split(/\n/).last.split(/,/).map(&:to_i)
  nearby_tickets = nearby_tickets.split(/\n/)[1..-1].map { |line| line.split(/,/).map(&:to_i) }
  all_ranges = ranges.values.reduce(:+)
  result = nearby_tickets.reduce(:+).reject { |i| all_ranges.any? { |range| range.include?(i) } }
  result.sum
end

puts process(File.read('input'))
