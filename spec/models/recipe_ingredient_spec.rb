require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe "validations" do
    it "will persist with quantity > 0" do
      beef = Ingredient.create!(name: "Beef", category: "protein")
      recipe = Recipe.create!(title: "Beef Stew")
      recipe_ingredient = RecipeIngredient.create!(recipe: recipe, ingredient: beef, quantity: 1)
      expect(recipe_ingredient.persisted?).to eq(true)
    end

    it "only persists if quantity > 0" do
      beef = Ingredient.create!(name: "Beef", category: "protein")
      expect { RecipeIngredient.create!(ingredient: beef, quantity: 0) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
