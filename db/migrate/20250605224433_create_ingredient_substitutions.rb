class CreateIngredientSubstitutions < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_substitutions do |t|
      t.string :ingredient_name
      t.string :substitution_name

      t.timestamps
    end

    add_index :ingredient_substitutions, :ingredient_name
    add_index :ingredient_substitutions, :substitution_name
    add_index :ingredient_substitutions, [:ingredient_name, :substitution_name], unique: true
  end
end
