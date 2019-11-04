# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191104145255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.date "balance_date"
    t.decimal "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
  end

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "account_name"
    t.integer "order_in_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "next_occurrence"
  end

  create_table "transaction_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "order_in_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.date "transaction_date"
    t.string "vendor_name"
    t.decimal "amount"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "repeating_transfer_id"
    t.index ["from_account_id"], name: "index_transfers_on_from_account_id"
    t.index ["to_account_id"], name: "index_transfers_on_to_account_id"
    t.index ["user_id", "transfer_date"], name: "index_transfers_on_user_id_and_transfer_date", order: { transfer_date: :desc }
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "password_digest"
    t.string "remember_token"
    t.string "time_zone"
  end

end
