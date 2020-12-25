require 'byebug'

MAGIC_NUMBER = 20201227
SUBJECT_NUMBER = 7

def loop_size(public_key)
  loop_size = 0
  value = 1
  loop do
    value = (value * SUBJECT_NUMBER) % MAGIC_NUMBER
    loop_size += 1
    return loop_size if public_key.to_i == value
  end
end

def transform(subject_number, loop_size)
  iteration = 0
  value = 1
  loop do
    value = (value * subject_number) % MAGIC_NUMBER
    iteration += 1
    return value if iteration == loop_size
  end
end

def process
  card_public_key = 11239946
  door_public_key = 10464955
  card_loop_size = loop_size(card_public_key)
  transform(door_public_key, card_loop_size)
end

puts process.inspect
