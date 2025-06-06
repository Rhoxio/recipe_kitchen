FactoryBot.define do
  factory :recipe_ingredient do
    recipe { nil }
    ingredient { nil }
    quantity { 1 }
  end
end
