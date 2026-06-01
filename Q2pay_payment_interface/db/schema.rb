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

ActiveRecord::Schema[8.1].define(version: 2026_05_28_121011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_logs", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.uuid "loggable_id", null: false
    t.string "loggable_type", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["loggable_type", "loggable_id"], name: "index_activity_logs_on_loggable"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "address"
    t.integer "bank_id"
    t.string "bank_name"
    t.string "branch"
    t.string "city"
    t.string "district", limit: 50
    t.string "ifsc"
    t.string "state"
    t.index ["ifsc"], name: "index_banks_on_ifsc_code", unique: true
  end

  create_table "otps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expiry"
    t.boolean "is_used"
    t.integer "otp"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_otps_on_user_id"
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "amount"
    t.datetime "created_at", null: false
    t.uuid "receiver_acc_id", null: false
    t.uuid "source_acc_id", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_acc_id"], name: "index_payments_on_receiver_acc_id"
    t.index ["source_acc_id"], name: "index_payments_on_source_acc_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aadhar_no", null: false
    t.datetime "created_at", null: false
    t.string "email_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "mobile_no", null: false
    t.string "pan_no", null: false
    t.string "password_digest"
    t.string "role", default: "user"
    t.boolean "status"
    t.datetime "updated_at", null: false
    t.index ["aadhar_no"], name: "index_users_on_aadhar_no", unique: true
    t.index ["email_id"], name: "index_users_on_email_id", unique: true
    t.index ["mobile_no"], name: "index_users_on_mobile_no", unique: true
    t.index ["pan_no"], name: "index_users_on_pan_no", unique: true
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "users"
  add_foreign_key "otps", "users"
  add_foreign_key "payments", "accounts", column: "receiver_acc_id"
  add_foreign_key "payments", "accounts", column: "source_acc_id"
end
