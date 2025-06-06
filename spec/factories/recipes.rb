FactoryBot.define do
  factory :recipe do
    title { "Pancake" }
    instructions { "Whip all ingredients together and put into greased pan. Flip then browned, serve hot with syrup." }

    after(:create) do |recipe|
      flour = create(:flour)
      eggs  = create(:eggs)
      milk  = create(:milk)
      sugar = create(:sugar)

      create(:recipe_ingredient, recipe: recipe, ingredient: flour, quantity: 2)
      create(:recipe_ingredient, recipe: recipe, ingredient: eggs,  quantity: 2)
      create(:recipe_ingredient, recipe: recipe, ingredient: milk,  quantity: 1)
      create(:recipe_ingredient, recipe: recipe, ingredient: sugar, quantity: 1)
    end
  end
end
