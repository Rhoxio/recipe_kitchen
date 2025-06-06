require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user){ create(:user) }

  describe "associations" do

    it "can associate to recipes" do
      recipe = create(:recipe)
      user.recipes << recipe
      expect(user.recipes.length > 0).to eq(true)
    end

    it "associates to PantryItem" do
      ingredient = create(:eggs)
      user.ingredients << ingredient
      expect(user.pantry_items.length > 0).to eq(true)
    end
  end

  describe "query moethods" do
    it "pulls the ingredient_count_for" do
      ingredient = create(:eggs)
      user.ingredients << [ingredient, ingredient]
      result = user.ingredient_count_for(ingredients: [ingredient])
      expect(result[ingredient.id]).to eq(2)
    end

    it "pulls ingredients_by_name" do
      ingredient = create(:eggs)
      user.ingredients << [ingredient, ingredient]
      result = user.ingredients_by_name
    end
  end
end
