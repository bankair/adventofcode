def process(input)
  timestamp, bus_ids = input.split(/\n/)
  timestamp = timestamp.to_i
  bus_ids = bus_ids.split(/,/).reject { |id| id =~ /x/ }.map(&:to_i)
  result = bus_ids.map { |id| [id, wait(timestamp, id)] }.sort_by(&:last).first
  result.reduce(:*)
end

def wait(target, id)
  cursor = (target / id) * id
  cursor += id if cursor < target
  cursor - target
end

puts process(File.read('input'))
