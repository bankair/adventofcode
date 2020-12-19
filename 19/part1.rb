def regexp(rules, cursor = '0')
  value = rules[cursor]
  if value =~ /"(.)"/
    return /#{Regexp.last_match[1]}/
  end
  results = value.split('|').map do |match|
    Regexp.new(match.scan(/\d+/).map { |e| regexp(rules, e).source }.join)
  end
  results.size == 1 ? results.first : Regexp.new("(#{results.map(&:source).join('|')})")
end

def process(input)
  rules, messages = input.split(/\n\n/).map { |e| e.split(/\n/) }
  rules = Hash[rules.map { |str| str.split(/: /) }]
  re = /^#{regexp(rules).source}$/
  messages.select { |message| message.match(re) }.count
end

puts process(File.read('input'))
