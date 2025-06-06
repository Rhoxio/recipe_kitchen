class RecipeEligibilityChecker

  attr_reader :missing_ingredients

  EligibilityStatus = Struct.new(:missing_ingredients, :success, :substitution_map)

  def initialize(recipe:, user:, allow_substitutions: false)
    @user = user
    @recipe = recipe
    @allow_substitutions = allow_substitutions
    @missing_ingredients = []
    @grouped_recipe_ingredients = nil
    @grouped_user_ingredients = nil
    @substitution_map = {}
  end

  def self.call(recipe:, user:, return_result: false, allow_substitutions: false)
    new(recipe:, user:, allow_substitutions:).call(return_result:)
  end

  def call(return_result: false)
    @grouped_recipe_ingredients = @recipe.ingredients_by_name
    @grouped_user_ingredients = @user.ingredients_by_name

    recipe_ingredients_tally = @grouped_recipe_ingredients.transform_values {_1.length}
    user_ingredients_tally = @grouped_user_ingredients.transform_values {_1.length}

    projected_consumption = recipe_ingredients_tally.each_with_object({}) do |(key, required_num), hash|
      available = user_ingredients_tally[key] || 0
      hash[key] = available - required_num
    end

    @missing_ingredients = projected_consumption.select{ |k, v| v < 0 }.transform_values(&:abs)

    substitute! if !@missing_ingredients.empty? && @allow_substitutions

    return @missing_ingredients.empty? unless return_result
    return EligibilityStatus.new(@missing_ingredients, @missing_ingredients.empty?, @substitution_map)
  end

  def substitute!
    keys_to_remove = []
    @missing_ingredients.dup.each do |missing_name, missing_count|
      # Substitutions must be of a consistent type - mixing oat milk and almond milk as sub isn't acceptable
      possible_subs = IngredientSubstitution.valid_substitutes_for(missing_name)

      substitute_name = possible_subs.detect do |sub_name|
        available_ingredients = @grouped_user_ingredients[sub_name]
        next unless available_ingredients
        available_ingredients.size >= missing_count
      end

      if substitute_name
        keys_to_remove << missing_name
        @substitution_map[missing_name] = substitute_name
      end
    end
    keys_to_remove.each { |key| @missing_ingredients.delete(key) }
  end
end