# frozen_string_literal: true

require 'set'

def small?(string)
  string !~ /^[A-Z]/
end

def last_cave?(string)
  string == 'end'
end

def process(input)
  paths = {}
  input.split(/\n/).each do |line|
    a, b = line.split('-')
    (paths[a] ||= []) << b
    (paths[b] ||= []) << a
  end
  visit('start', paths, ['start'], Set.new(['start'])).count
end

def visit(current, paths, stack, visited)
  return [stack.join(',')] if last_cave?(current)

  result = []
  paths[current].each do |connected|
    next if small?(connected) && visited.include?(connected)

    result += visit(connected, paths, stack + [connected], visited + Set.new([connected]))
  end
  result
end

def test(input, expected)
  actual = process(input)
  if actual != expected
    puts "ERROR: #{actual.inspect} != #{expected}"
    puts "INPUT:\n#{input}"
    exit 1
  end
  puts "SUCCESS => #{actual.inspect}"
end

test(<<~TEST, 226)
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
TEST

puts process(File.read('input'))
