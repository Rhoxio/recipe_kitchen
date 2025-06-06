require 'rails_helper'

RSpec.describe Recipe, type: :model do

  describe "public interface" do
    describe "ingredients_by_instance" do
      it "pulls the full duplicate instances based on quantity" do
        recipe = create(:recipe)
        grouped = recipe.ingredients_by_instance.group_by(&:name).transform_values{_1.size}
        expect(grouped["Flour"]).to eq(2)
        expect(grouped["Eggs"]).to eq(2)
        expect(grouped["Milk"]).to eq(1)
        expect(grouped["Sugar"]).to eq(1)
      end
    end
  end
end
