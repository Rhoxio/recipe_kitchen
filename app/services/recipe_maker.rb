class RecipeMaker

  RecipeResult = Struct.new(:recipe, :status, :user, :consumed_ingredients)

  def initialize(recipe:, user:, allow_substitutions:)
    @user = user
    @recipe = recipe
    @allow_substitutions = allow_substitutions
  end

  def self.call(recipe:, user:, allow_substitutions: false)
    new(recipe:, user:, allow_substitutions:).call
  end

  def call
    begin
      consumer = IngredientConsumer.call(user: @user, recipe: @recipe, allow_substitutions: @allow_substitutions)
      return RecipeResult.new(recipe: @recipe, user: @user, status: "created", consumed_ingredients: consumer.consumed_ingredients)
    rescue => e
      Rails.logger.error("RecipeMaker failure for user_id=#{@user.id}, recipe_id=#{@recipe.id}: #{e.class} - #{e.message}")
      return RecipeResult.new(recipe: @recipe, user: @user, status: "failed")
    end
  end

end