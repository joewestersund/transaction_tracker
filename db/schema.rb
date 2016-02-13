# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140101231640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", force: :cascade do |t|
    t.integer  "account_id"
    t.date     "balance_date"
    t.decimal  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "account_name"
    t.integer  "order_in_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "order_in_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.date     "transaction_date"
    t.string   "vendor_name"
    t.decimal  "amount"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "account_id"
    t.integer  "transaction_category_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree
  add_index "transactions", ["transaction_category_id"], name: "index_transactions_on_transaction_category_id", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.date     "transfer_date"
    t.decimal  "amount"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
  end

  add_index "transfers", ["from_account_id"], name: "index_transfers_on_from_account_id", using: :btree
  add_index "transfers", ["to_account_id"], name: "index_transfers_on_to_account_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "time_zone"
  end

end
