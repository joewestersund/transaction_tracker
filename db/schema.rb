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

ActiveRecord::Schema[7.0].define(version: 2022_10_08_233013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.date "balance_date"
    t.decimal "balance"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "account_name"
    t.integer "order_in_list"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "data_points", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "workout_route_id"
    t.bigint "data_type_id"
    t.bigint "dropdown_option_id"
    t.text "text_value"
    t.decimal "decimal_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_adtv_on_adt"
    t.index ["dropdown_option_id"], name: "index_adtv_on_adto"
    t.index ["user_id"], name: "index_data_points_on_user_id"
    t.index ["workout_route_id"], name: "index_data_points_on_workout_route_id"
  end

  create_table "data_types", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "workout_type_id"
    t.string "name"
    t.string "field_type"
    t.string "units"
    t.text "description"
    t.integer "order_in_list"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "workout_type_id", "order_in_list"], name: "index_adt_on_user_and_workout_type_and_order"
    t.index ["user_id"], name: "index_data_types_on_user_id"
    t.index ["workout_type_id"], name: "index_data_types_on_workout_type_id"
  end

  create_table "default_data_points", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "route_id"
    t.bigint "data_type_id"
    t.bigint "dropdown_option_id"
    t.text "text_value"
    t.decimal "decimal_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_ddp_on_dt"
    t.index ["dropdown_option_id"], name: "index_ddp_on_do"
    t.index ["route_id"], name: "index_default_data_points_on_route_id"
    t.index ["user_id"], name: "index_default_data_points_on_user_id"
  end

  create_table "dropdown_options", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "data_type_id"
    t.string "name"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type_id"], name: "index_dropdown_options_on_data_type_id"
    t.index ["user_id", "data_type_id", "order_in_list"], name: "index_adto_on_user_and_adt_and_order"
    t.index ["user_id"], name: "index_dropdown_options_on_user_id"
  end

  create_table "repeating_transactions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "vendor_name"
    t.integer "account_id"
    t.integer "transaction_category_id"
    t.decimal "amount"
    t.text "description"
    t.date "repeat_start_date"
    t.integer "ends_after_num_occurrences"
    t.date "ends_after_date"
    t.string "repeat_period"
    t.integer "repeat_every_x_periods"
    t.integer "repeat_on_x_day_of_period"
    t.date "last_occurrence_added"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "next_occurrence"
  end

  create_table "repeating_transfers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "from_account_id"
    t.integer "to_account_id"
    t.decimal "amount"
    t.text "description"
    t.date "repeat_start_date"
    t.integer "ends_after_num_occurrences"
    t.date "ends_after_date"
    t.string "repeat_period"
    t.integer "repeat_every_x_periods"
    t.integer "repeat_on_x_day_of_period"
    t.date "last_occurrence_added"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "next_occurrence"
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "workout_type_id"
    t.string "name"
    t.text "description"
    t.integer "order_in_list"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "workout_type_id", "order_in_list"], name: "index_routes_on_user_id_and_workout_type_id_and_order_in_list"
    t.index ["user_id"], name: "index_routes_on_user_id"
    t.index ["workout_type_id"], name: "index_routes_on_workout_type_id"
  end

  create_table "transaction_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "order_in_list"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.date "transaction_date"
    t.string "vendor_name"
    t.decimal "amount"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.integer "account_id"
    t.integer "transaction_category_id"
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "repeating_transaction_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["transaction_category_id"], name: "index_transactions_on_transaction_category_id"
    t.index ["user_id", "transaction_date"], name: "index_transactions_on_user_id_and_transaction_date", order: { transaction_date: :desc }
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "from_account_id"
    t.integer "to_account_id"
    t.date "transfer_date"
    t.decimal "amount"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "repeating_transfer_id"
    t.index ["from_account_id"], name: "index_transfers_on_from_account_id"
    t.index ["to_account_id"], name: "index_transfers_on_to_account_id"
    t.index ["user_id", "transfer_date"], name: "index_transfers_on_user_id_and_transfer_date", order: { transfer_date: :desc }
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "password_digest"
    t.string "remember_token"
    t.string "time_zone"
    t.bigint "user_group_id"
    t.index ["user_group_id"], name: "index_users_on_user_group_id"
  end

  create_table "workout_routes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "workout_id"
    t.bigint "route_id"
    t.integer "repetitions"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_workout_routes_on_route_id"
    t.index ["user_id"], name: "index_workout_routes_on_user_id"
    t.index ["workout_id"], name: "index_workout_routes_on_workout_id"
  end

  create_table "workout_types", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "order_in_list"], name: "index_workout_types_on_user_id_and_order_in_list"
    t.index ["user_id"], name: "index_workout_types_on_user_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "workout_type_id"
    t.date "workout_date"
    t.integer "year"
    t.integer "month"
    t.integer "week"
    t.integer "day"
    t.integer "week_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "workout_date"], name: "index_workouts_on_user_id_and_workout_date", order: { workout_date: :desc }
    t.index ["user_id", "year", "month", "week"], name: "index_workouts_on_user_id_and_year_and_month_and_week", order: { year: :desc, month: :desc, week: :desc }
    t.index ["user_id"], name: "index_workouts_on_user_id"
    t.index ["workout_type_id"], name: "index_workouts_on_workout_type_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
