class IngredientConsumer

  class MissingIngredientsError < StandardError; end
  ConsumedResult = Struct.new(:user, :recipe, :consumed_ingredients)

  def initialize(user:, recipe:, allow_substitutions: false)
    @user = user
    @recipe = recipe
    @allow_substitutions = allow_substitutions
    @consumption_data = consumption_data
  end

  def self.call(user:, recipe:, allow_substitutions: false)
    new(user:, recipe:, allow_substitutions:).call
  end

  def call
    raise MissingIngredientsError, "Missing ingredients: #{@consumption_data.missing_ingredients.inspect}" unless @consumption_data.success
    grouped_recipe_ingredients = @recipe.ingredients_by_instance.group_by(&:name)
    user_ingredients_by_name = @user.ingredients_by_name

    removed_ingredients = []
    ActiveRecord::Base.transaction do
      @consumption_data.ingredients.each do |name, count|
        user_ingredients = user_ingredients_by_name[name]&.sort_by(&:created_at) || []
        ingredients_to_remove = user_ingredients.last(count)
        removed_ingredients.concat(ingredients_to_remove)
      end

      @user.ingredients = @user.ingredients - removed_ingredients
      @user.save!
    end

    return ConsumedResult.new(@user, @recipe, removed_ingredients)
  end

  private

  def consumption_data
    RecipeIngredientResolver.call(
      user: @user,
      recipe: @recipe,
      allow_substitutions: @allow_substitutions
    )
  end

end