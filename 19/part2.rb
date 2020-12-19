def regexp(rules, cursor = '0')
  value = rules[cursor]
  if value =~ /"(.)"/
    return /#{Regexp.last_match[1]}/
  end
  return /#{regexp(rules, '42')}+/ if cursor == '8'
  if cursor == '11'
    re_42 = regexp(rules, '42').source
    re_31 = regexp(rules, '31').source
    matches = 14.times.map do |i|
      (re_42 * i) + re_42 + re_31 + (re_31 * i)
    end
    return /(#{matches.join('|')})/
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

puts process(File.read('input2'))
