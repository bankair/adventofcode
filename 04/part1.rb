MANDATORY_INPUTS = %w(byr iyr eyr hgt hcl ecl pid).freeze

def valid?(passport)
  (passport.keys & MANDATORY_INPUTS).size == MANDATORY_INPUTS.size
end

def count(buffer)
  passports = []
  current_passport = {}
  buffer.split(/\n/).each do |line|
    current_passport =
      if line.empty?
        passports << current_passport
        {}
      else
        current_passport.merge(Hash[line.split(' ').map { |keyvalue| keyvalue.split(':') }])
      end
  end
  passports << current_passport if current_passport
  passports.select { |passport| valid?(passport) }.count
end

puts count(File.read('input'))

