require 'set'

def process(input)
  rules, my_ticket, nearby_tickets = input.split(/\n\n/).map(&:chomp)
  rules = Hash[
    rules.split(/\n/).map do |line|
      key, rules =  line.split(/: /)
      [key, rules.split(/ or /).map { |str| values = str.split(/-/).map(&:to_i); values.first..values.last }]
    end
  ]
  my_ticket = my_ticket.split(/\n/).last.split(/,/).map(&:to_i)
  nearby_tickets = nearby_tickets.split(/\n/)[1..-1].map { |line| line.split(/,/).map(&:to_i) }
  candidates = Hash[rules.keys.map { |key| [key, Set.new(my_ticket.size.times.to_a)] }]

  all_ranges = rules.values.reduce(:+)
  nearby_tickets.reject! do |ticket|
    ticket.any? { |value| all_ranges.none? { |range| range.include?(value) } }
  end
  nearby_tickets.each do |nearby_ticket|
    nearby_ticket.each_with_index do |value, index|
      rules.each do |key, ranges|
        candidates[key].delete(index) unless ranges.any? { |range| range.include?(value) }
      end
    end
  end
  puts candidates.inspect
  positions = {}
  loop do
    break if candidates.empty?
    uniques = candidates.select { |key, values| values.count == 1 }
    uniques.each do |key, set|
      positions[key] = set.first
      candidates.values.each { |e| e.delete(positions[key]) }
      candidates.delete(key)
    end
  end
  positions.select { |key, index| key =~ /^departure/ }.values.map { |index| my_ticket[index] }.reduce(:*)
end

puts process(File.read('input'))
