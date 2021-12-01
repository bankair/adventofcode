# frozen_string_literal: true

input = File.readlines('input').map(&:to_i)
puts(input[1..-1].zip(input[0..-2]).count { |a, b| a > b })
