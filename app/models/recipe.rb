class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  def ingredients_by_instance
    recipe_ingredients.map do |recipe_ingredient|
      ingredient_instances = []
      recipe_ingredient.quantity.times {ingredient_instances << recipe_ingredient.ingredient}
      ingredient_instances
    end.compact.flatten
  end

  def ingredients_by_name
    ingredients_by_instance.group_by(&:name)
  end
end
