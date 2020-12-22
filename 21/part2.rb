def deduce_ingredient_per_allergen(candidates_per_allergen)
  ingredient_per_allergen = {}
  loop do
    candidates_per_allergen.keys.each do |allergen|
      candidates = candidates_per_allergen[allergen].reduce(:&)
      if candidates.size == 1
        ingredient = candidates.first
        ingredient_per_allergen[allergen] = ingredient
        candidates_per_allergen.delete(allergen)
        candidates_per_allergen.values.each do |ingredient_lists|
          ingredient_lists.each { |ingredients| ingredients.delete(ingredient) }
          ingredient_lists.reject!(&:empty?)
        end
        candidates_per_allergen.reject! { |key, value| value.empty? }
      end
    end
    break if candidates_per_allergen.empty?
  end
  ingredient_per_allergen
end

def process(input)
  input = Hash[
    input.split(/\n/).map do |line|
      [line[/[a-z ]+/][0..-2].split, line[/\(contains .*\)/][10..-2].split(', ')]
    end
  ]
  candidates_per_allergen = {}
  input.values.reduce([], :+).uniq.each do |allergen|
    candidates = input.select { |ingredients, allergens| allergens.include?(allergen) }.keys
    candidates_per_allergen[allergen] = candidates
  end
  ingredient_per_allergen = deduce_ingredient_per_allergen(candidates_per_allergen)
  ingredient_per_allergen.to_a.sort_by(&:first).map(&:last).join(',')
end

puts process(File.read('input'))
