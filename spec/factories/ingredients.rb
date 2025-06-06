FactoryBot.define do
  factory :ingredient do
    name {"Ingredient"}
    category {"Dairy"}

    factory :flour do
      name     { "Flour" }
      category { "Baking" }
    end

    factory :sugar do
      name     { "Sugar" }
      category { "Baking" }
    end

    factory :eggs do
      name     { "Eggs" }
      category { "Dairy" }
    end

    factory :duck_eggs do
      name     { "Duck Eggs" }
      category { "Dairy" }
    end

    factory :quail_eggs do
      name     { "Quail Eggs" }
      category { "Dairy" }
    end

    factory :milk do
      name     { "Milk" }
      category { "Dairy" }
    end

    factory :almond_milk do
      name     { "Almond Milk" }
      category { "Dairy" }
    end

    factory :oat_milk do
      name     { "Oat Milk" }
      category { "Dairy" }
    end

    factory :goat_milk do
      name     { "Goat Milk" }
      category { "Dairy" }
    end
  end

end
