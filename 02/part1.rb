count = File.readlines('input').select do |input|
  policy, password = input.split(/: /)
  cardinality, char = policy.split(/ /)
  min, max = cardinality.split(/-/).map(&:to_i)
  (min..max).include?(password.scan(char).count)
end.count

puts count
