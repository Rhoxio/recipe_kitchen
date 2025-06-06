# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_05_224433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ingredient_substitutions", force: :cascade do |t|
    t.string "ingredient_name"
    t.string "substitution_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_name", "substitution_name"], name: "idx_on_ingredient_name_substitution_name_4746c26ad6", unique: true
    t.index ["ingredient_name"], name: "index_ingredient_substitutions_on_ingredient_name"
    t.index ["substitution_name"], name: "index_ingredient_substitutions_on_substitution_name"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pantry_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ingredient_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_pantry_items_on_ingredient_id"
    t.index ["user_id"], name: "index_pantry_items_on_user_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_recipes", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_user_recipes_on_recipe_id"
    t.index ["user_id"], name: "index_user_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pantry_items", "ingredients"
  add_foreign_key "pantry_items", "users"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "user_recipes", "recipes"
  add_foreign_key "user_recipes", "users"
end
