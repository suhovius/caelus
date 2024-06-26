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

ActiveRecord::Schema[7.1].define(version: 2024_04_30_004659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_admin_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_admin_roles_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admin_users_admin_roles", id: false, force: :cascade do |t|
    t.bigint "admin_user_id"
    t.bigint "admin_role_id"
    t.index ["admin_role_id"], name: "index_admin_users_admin_roles_on_admin_role_id"
    t.index ["admin_user_id", "admin_role_id"], name: "idx_on_admin_user_id_admin_role_id_c0859d813f"
    t.index ["admin_user_id"], name: "index_admin_users_admin_roles_on_admin_user_id"
  end

  create_table "observations_results", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.float "temperature", null: false
    t.float "pressure", null: false
    t.float "humidity", null: false
    t.float "wind_speed", null: false
    t.float "wind_deg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_observations_results_on_source_id"
  end

  create_table "observations_sources", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "origin_type", null: false
    t.bigint "origin_id", null: false
    t.string "name", null: false
    t.text "description"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "organization_id"], name: "index_observations_sources_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_observations_sources_on_organization_id"
    t.index ["origin_type", "origin_id"], name: "index_observations_sources_on_origin"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weather_api_credentials", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.string "handler_key", null: false
    t.string "api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "organization_id"], name: "index_weather_api_credentials_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_weather_api_credentials_on_organization_id"
  end

  create_table "weather_devices", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.string "uuid"
    t.string "token"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "organization_id"], name: "index_weather_devices_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_weather_devices_on_organization_id"
  end

  add_foreign_key "observations_results", "observations_sources", column: "source_id"
  add_foreign_key "observations_sources", "organizations"
  add_foreign_key "weather_api_credentials", "organizations"
  add_foreign_key "weather_devices", "organizations"
end
