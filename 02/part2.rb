count = File.readlines('input').select do |input|
  policy, password = input.split(/: /)
  positions, char = policy.split(/ /)
  pos1, pos2 = positions.split(/-/).map { |index| index.to_i - 1 }
  (password[pos1] == char) ^ (password[pos2] == char)
end.count

puts count
