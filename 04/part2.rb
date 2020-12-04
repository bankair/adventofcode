MANDATORY_INPUTS = %w(byr iyr eyr hgt hcl ecl pid).freeze
VALIDATIONS = {
  "byr" => -> (value) { value =~ /^\d{4}$/ && (1920..2002).include?(value.to_i) },
  "iyr" => -> (value) { value =~ /^\d{4}$/ && (2010..2020).include?(value.to_i) },
  "eyr" => -> (value) { value =~ /^\d{4}$/ && (2020..2030).include?(value.to_i) },
  "hgt" => -> (value) do
    value =~ /^\d+(cm|in)$/ &&
      (value[/(cm|in)/] == 'cm' ? (150..193) : (59..76)).include?(value[/\d+/].to_i)
  end,
  "hcl" => -> (value) { value =~ /^#[a-f0-9]{6}$/ },
  "ecl" => -> (value) { %w(amb blu brn gry grn hzl oth).include?(value) },
  "pid" => -> (value) { value =~ /^\d{9}$/ },
}

def valid?(passport)
  VALIDATIONS.all? do |key, validation|
    value = passport[key]
    value && validation.(value)
  end
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
