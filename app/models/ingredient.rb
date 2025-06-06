class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  has_many :pantry_items
  has_many :users, through: :pantry_items
end
