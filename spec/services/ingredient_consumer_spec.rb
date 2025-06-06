require 'rails_helper'

RSpec.describe IngredientConsumer do

  describe "call" do

    describe "happy default" do
      let!(:user){create(:user)}

      let!(:eggs){create(:eggs)}
      let!(:second_eggs){create(:eggs)}
      let!(:sugar){create(:sugar)}
      let!(:milk){create(:milk)}
      let!(:flour){create(:flour)}
      let!(:second_flour){create(:flour)}

      let!(:pancake_recipe){create(:recipe)}

      let!(:recipe_eggs){pancake_recipe.ingredients.where(name: "Eggs")}
      let!(:recipe_sugar){pancake_recipe.ingredients.where(name: "Sugar")}
      let!(:recipe_milk){pancake_recipe.ingredients.where(name: "Milk")}
      let!(:recipe_flour){pancake_recipe.ingredients.where(name: "Flour")}

      before do
        user.ingredients << [eggs, second_eggs, sugar, flour, second_flour, milk]
      end

      it "consumes the ingredients" do
        result = IngredientConsumer.call(user: user, recipe: pancake_recipe)
        user.reload
        expect(user.ingredients.where(name: "Eggs").length).to eq(0)
        expect(user.ingredients.where(name: "Sugar").length).to eq(0)
        expect(user.ingredients.where(name: "Flour").length).to eq(0)
        expect(user.ingredients.where(name: "Milk").length).to eq(0)
      end
    end


    describe "substitutions" do

      let!(:user){create(:user)}

      let(:milk_types){[
        "Almond Milk",
        "Oat Milk",
        "Goat Milk"
      ]}

      let(:egg_types){[
        "Duck Eggs",
        "Quail Eggs"
      ]}

      let(:user_ingredients){[
        create(:goat_milk),
        create(:oat_milk),
        create(:sugar),
        [create(:eggs), create(:duck_eggs)],
        [create(:flour), create(:flour)]
      ].flatten}

      # Takes 2 eggs and 2 flour
      let!(:pancake_recipe){create(:recipe)}

      let!(:recipe_eggs){pancake_recipe.ingredients.where(name: "Eggs")}
      let!(:recipe_sugar){pancake_recipe.ingredients.where(name: "Sugar")}
      let!(:recipe_milk){pancake_recipe.ingredients.where(name: "Milk")}
      let!(:recipe_flour){pancake_recipe.ingredients.where(name: "Flour")}

      before do
        milk_types.each do |milk_type|
          IngredientSubstitution.create!(ingredient_name: "Milk", substitution_name: milk_type)
        end

        egg_types.each do |egg_type|
          IngredientSubstitution.create!(ingredient_name: "Eggs", substitution_name: egg_type)
        end

        user.ingredients << user_ingredients
      end

      it "consumes the ingredients" do
        result = IngredientConsumer.call(user: user, recipe: pancake_recipe, allow_substitutions: true)
        expect(result.consumed_ingredients.size).to eq(6)

        user.reload
        expect(user.ingredients.where(name: "Eggs").length).to eq(0)
        expect(user.ingredients.where(name: "Duck Eggs").length).to eq(0)
        expect(user.ingredients.where(name: "Sugar").length).to eq(0)
        expect(user.ingredients.where(name: "Flour").length).to eq(0)
        expect(user.ingredients.where(name: "Oat Milk").length).to eq(0)
        expect(user.ingredients.where(name: "Goat Milk").length).to eq(1)
      end
    end
  end

end