require 'rails_helper'

RSpec.describe IngredientSubstitution, type: :model do

  let(:milk_types){[
    "Almond Milk",
    "Oat Milk",
    "Goat Milk"
  ]}

  before do
    milk_types.each do |milk_type|
      IngredientSubstitution.create!(ingredient_name: "Milk", substitution_name: milk_type)
    end
  end

  # it "sandboxes" do
  #   ap IngredientSubstitution.for_ingredient_name("Milk")
  #   ap IngredientSubstitution.valid_substitutes_for("Milk")
  # end

  describe "queries" do

    it "detects the correct substitutions" do
      result = IngredientSubstitution.for_ingredient_name("Milk")
      expect(result.length > 0).to eq(true)
      expect(result.first&.substitution_name).to eq("Almond Milk")
    end

    it "detects the correct original name" do
      result = IngredientSubstitution.substitutes_for("Almond Milk")
      expect(result.length > 0).to eq(true)
      expect(result.map(&:ingredient_name).include?("Milk")).to eq(true)
    end

    describe "name-returned queries" do
      describe "#valid_substitutes_for" do
        it "returns the applicable name" do
          result = IngredientSubstitution.valid_substitutes_for("Milk")
          expect(result.include?("Almond Milk"))
        end

        it "returns the applicable name" do
          result = IngredientSubstitution.valid_substitutes_for("Milk")
          expect(result.include?("Almond Milk"))
        end
      end

      describe "#valid_ingredient_substitution_for" do
        it "returns the applicable name" do
          result = IngredientSubstitution.valid_ingredient_substitution_for("Almond Milk")
          expect(result.include?("Milk"))
        end
      end

      describe "#full_ingredient_compatability" do
        it "returns the full list" do
          result = IngredientSubstitution.full_ingredient_compatibility("Oat Milk")
          milk_types.each do |milk_type|
            expect(milk_type.in?(result)).to eq(true)
          end
        end
      end
    end

  end
end
