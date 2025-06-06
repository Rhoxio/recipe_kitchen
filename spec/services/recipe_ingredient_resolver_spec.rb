require 'rails_helper'

RSpec.describe RecipeEligibilityChecker do

  let!(:user){create(:user)}
  let!(:recipe){create(:recipe)}
  let(:ingredients){recipe.ingredients}

  describe "initialization" do

    describe "true cases" do
      before do
        # Pancakes take at least 2 of each ingredient. We want the user to have enough by default.
        user.ingredients << [ingredients, ingredients].flatten
      end

      it "correctly detects eligibility" do
        result = RecipeEligibilityChecker.call(recipe: recipe, user: user)
        expect(result).to eq(true)
      end

      it "returned status struct" do
        result = RecipeEligibilityChecker.call(recipe: recipe, user: user, return_result: true)
        expect(result.missing_ingredients.empty?).to eq(true)
        expect(result.success).to eq(true)
      end
    end

    describe "false cases" do
      before do
        # Pancakes take 2 of some, 1 of other ingredients. We want the user to have LESS than enough conditionally.
        user.ingredients << [ingredients].flatten
      end

      it "correctly detects ineligibility" do
        user.ingredients = []
        user.save!
        result = RecipeEligibilityChecker.call(recipe: recipe, user: user)
        expect(result).to eq(false)
      end

      it "returned status struct" do
        result = RecipeEligibilityChecker.call(recipe: recipe, user: user, return_result: true)
        expect(result.missing_ingredients.keys.in?(["Flour", "Eggs"]))
        expect(result.success).to eq(false)
      end
    end

    describe "substitution" do

      describe "with valid substitutions" do

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

        before do
          milk_types.each do |milk_type|
            IngredientSubstitution.create!(ingredient_name: "Milk", substitution_name: milk_type)
          end

          egg_types.each do |egg_type|
            IngredientSubstitution.create!(ingredient_name: "Eggs", substitution_name: egg_type)
          end

          user.ingredients << user_ingredients
        end

        it "will detect valid substitutions" do
          result = RecipeEligibilityChecker.call(recipe: recipe, user: user, return_result: true, allow_substitutions: true)
          expect(result.success).to eq(true)
          expect(result.missing_ingredients.blank?).to eq(true)
          expect(result.substitution_map["Eggs"]).to eq("Duck Eggs")
          expect(result.substitution_map["Milk"]).to eq("Oat Milk")
        end
      end

      describe "without valid substitutions" do
        let(:user_ingredients){[
          create(:goat_milk),
          create(:oat_milk),
          create(:sugar),
          [create(:eggs), create(:duck_eggs)],
          [create(:flour), create(:flour)]
        ].flatten}

        before do
          # No substitutions are defined!
          user.ingredients << user_ingredients
        end

        it "will handle missing substitutions" do
          result = RecipeEligibilityChecker.call(recipe: recipe, user: user, return_result: true, allow_substitutions: true)
          expect(result.success).to eq(false)
          expect(result.missing_ingredients["Milk"]).to eq(1)
          expect(result.missing_ingredients["Eggs"]).to eq(1)
        end
      end

    end

  end

end