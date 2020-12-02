puts File.readlines('input').map(&:to_i).combination(2).find { |a, b| a + b == 2020 }.reduce(:*)
