class IngredientSubstitution < ApplicationRecord
  scope :for_ingredient_name, ->(name){ where(ingredient_name: name) }
  scope :substitutes_for, ->(name){ where(substitution_name: name) }
  scope :where_either_matches, ->(name) {
    where(ingredient_name: name).or(where(substitution_name: name))
  }

  def self.valid_substitutes_for(name)
    for_ingredient_name(name).pluck(:substitution_name)
  end

  def self.valid_ingredient_substitution_for(name)
    substitutes_for(name).pluck(:ingredient_name)
  end

  def self.full_ingredient_compatibility(name)
    full_ingredient_list = where_either_matches(name)
    results = full_ingredient_list.flat_map do |substitution|
      [
        substitution.ingredient_name,
        *for_ingredient_name(substitution.ingredient_name).pluck(:substitution_name)
      ]
    end

    results.uniq
  end
end
