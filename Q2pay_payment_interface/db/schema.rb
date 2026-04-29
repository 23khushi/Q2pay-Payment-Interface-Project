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

ActiveRecord::Schema[8.1].define(version: 2026_04_28_061512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "acc_no"
    t.string "acc_type"
    t.bigint "balance"
    t.bigint "bank_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["acc_no"], name: "index_accounts_on_acc_no", unique: true
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.string "ifsc_code"
    t.datetime "updated_at", null: false
    t.index ["ifsc_code"], name: "index_banks_on_ifsc_code", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.bigint "receiver_acc_id", null: false
    t.string "receiver_acc_type"
    t.string "receiver_accno"
    t.string "receiver_bank_name"
    t.string "receiver_ifsc"
    t.string "receiver_name"
    t.bigint "source_acc_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["receiver_acc_id"], name: "index_transactions_on_receiver_acc_id"
    t.index ["source_acc_id"], name: "index_transactions_on_source_acc_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aadhar_no", null: false
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "mobile_no", null: false
    t.string "pan_no", null: false
    t.integer "pin"
    t.datetime "updated_at", null: false
    t.index ["aadhar_no"], name: "index_users_on_aadhar_no", unique: true
    t.index ["mobile_no"], name: "index_users_on_mobile_no", unique: true
    t.index ["pan_no"], name: "index_users_on_pan_no", unique: true
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "accounts", "users"
  add_foreign_key "transactions", "accounts", column: "receiver_acc_id"
  add_foreign_key "transactions", "accounts", column: "source_acc_id"
  add_foreign_key "transactions", "users"
end
