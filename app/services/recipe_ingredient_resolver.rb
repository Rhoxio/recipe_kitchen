class RecipeIngredientResolver

  attr_reader :missing_ingredients

  EligibilityStatus = Struct.new(:missing_ingredients, :success, :substitution_map, :ingredients)

  def initialize(recipe:, user:, allow_substitutions: false)
    @user = user
    @recipe = recipe
    @allow_substitutions = allow_substitutions
    @ingredients = {}
    @missing_ingredients = []
    @grouped_recipe_ingredients = nil
    @grouped_user_ingredients = nil
    @substitution_map = {}
  end

  def self.call(recipe:, user:,  allow_substitutions: false)
    new(recipe:, user:, allow_substitutions:).call
  end

  def call
    @grouped_recipe_ingredients = @recipe.ingredients_by_name
    @grouped_user_ingredients = @user.ingredients_by_name

    recipe_ingredients_tally = tally(@grouped_recipe_ingredients)
    user_ingredients_tally = tally(@grouped_user_ingredients)

    @missing_ingredients = compute_missing(recipe_ingredients_tally, user_ingredients_tally)
    @ingredients = compute_used(recipe_ingredients_tally, user_ingredients_tally)

    substitute! if !@missing_ingredients.empty? && @allow_substitutions

    return EligibilityStatus.new(@missing_ingredients, @missing_ingredients.empty?, @substitution_map, @ingredients)
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
        @ingredients[substitute_name] ||= 0
        @ingredients[substitute_name] += 1
      end
    end
    keys_to_remove.each { |key| @missing_ingredients.delete(key) }
    @ingredients.reject!{ |k,v| v <= 0 }
  end

  private

  def tally(grouped_ingredients)
    grouped_ingredients.transform_values(&:length)
  end

  def compute_missing(required, available)
    required.each_with_object({}) do |(name, count), hash|
      remaining = (available[name] || 0) - count
      hash[name] = remaining.abs if remaining < 0
    end
  end

  def compute_used(required, available)
    required.each_with_object({}) do |(name, needed), hash|
      have = available[name] || 0
      hash[name] = [needed, have].min
    end
  end

end