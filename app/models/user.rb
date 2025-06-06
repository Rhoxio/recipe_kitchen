class User < ApplicationRecord
  has_many :user_recipes, dependent: :destroy
  has_many :recipes, through: :user_recipes

  has_many :pantry_items, dependent: :destroy
  has_many :ingredients, through: :pantry_items

  # scope :ingredients_by_name, ->{joins(:ingredients).group()}

  def ingredient_count_for(ingredients:)
    ingredient_ids = ingredients.map(&:id)
    pantry_items.where(ingredient_id: ingredient_ids).group(:ingredient_id).count
  end

  def ingredients_by_name
    ingredients.group_by(&:name)
  end

  def consume_ingredients!(given_ingredients)
    name_grouped_given_ingredients = given_ingredients.group_by(&:name)
    user_ingredients_by_name = ingredients_by_name
    remaining_ingredients = []
    removed_ingredients = []

    ActiveRecord::Base.transaction do
      name_grouped_given_ingredients.each do |name, recipe_ingredients|
        user_ingredients = user_ingredients_by_name[name]&.sort_by(&:created_at) || []
        ingredients_to_remove = user_ingredients.last(recipe_ingredients.size)
        removed_ingredients.concat(ingredients_to_remove)
        remaining_ingredients.concat(user_ingredients - ingredients_to_remove)
      end

      self.ingredients = remaining_ingredients
      save!
    end

    return removed_ingredients
  end
end
