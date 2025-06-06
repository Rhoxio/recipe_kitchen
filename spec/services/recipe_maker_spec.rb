require 'rails_helper'

RSpec.describe RecipeMaker do

  let!(:user){create(:user)}
  let!(:recipe){create(:recipe)}

  describe "initialization" do

    before do
      # Pancakes take at least 2 of each ingredient. We want the user to have enough by default.
      ingredients = recipe.ingredients
      user.ingredients << [ingredients, ingredients].flatten
    end

    it "consumes and produces the recipe status" do
      result = RecipeMaker.call(recipe: recipe, user: user)
      expect(result.recipe).to eq(recipe)
      expect(result.user).to eq(user)
      expect(result.status).to eq("created")
      expect(result.consumed_ingredients.length == recipe.recipe_ingredients.sum(&:quantity)).to eq(true)
    end

    describe "error cases" do
      it "returns a failed status if not successful" do
        allow(IngredientConsumer).to receive(:call).and_raise(StandardError)
        result = RecipeMaker.call(recipe: recipe, user: user)
        expect(result.status).to eq("failed")
        expect(result.recipe).to eq(recipe)
        expect(result.user).to eq(user)
        expect(result.consumed_ingredients).to eq(nil)
      end
    end

  end


end