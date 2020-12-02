puts File.readlines('input').map(&:to_i).combination(3).find { |a, b, c| a + b + c == 2020 }.reduce(:*)
