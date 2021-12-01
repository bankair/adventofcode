# frozen_string_literal: true

input = File.readlines('input').map(&:to_i)
input = input[0..-3].zip(input[1..-2]).map(&:sum).zip(input[2..-1]).map(&:sum)
puts(input[1..-1].zip(input[0..-2]).count { |a, b| a > b })
