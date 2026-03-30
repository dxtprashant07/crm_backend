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

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000005) do
  create_table "activities", force: :cascade do |t|
    t.string "activity_type", null: false
    t.string "subject", null: false
    t.text "description"
    t.boolean "completed", default: false
    t.datetime "scheduled_at"
    t.integer "user_id"
    t.integer "contact_id"
    t.integer "deal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_type"], name: "index_activities_on_activity_type"
    t.index ["contact_id"], name: "index_activities_on_contact_id"
    t.index ["deal_id"], name: "index_activities_on_deal_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "industry"
    t.string "website"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "country"
    t.integer "size", default: 1
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "job_title"
    t.integer "status", default: 0
    t.integer "source", default: 5
    t.text "notes"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
    t.index ["email"], name: "index_contacts_on_email", unique: true
    t.index ["status"], name: "index_contacts_on_status"
  end

  create_table "deals", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "value", precision: 12, scale: 2, default: "0.0"
    t.string "stage", default: "prospecting"
    t.integer "probability", default: 10
    t.date "expected_close_date"
    t.text "notes"
    t.integer "contact_id"
    t.integer "company_id"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_deals_on_company_id"
    t.index ["contact_id"], name: "index_deals_on_contact_id"
    t.index ["owner_id"], name: "index_deals_on_owner_id"
    t.index ["stage"], name: "index_deals_on_stage"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "activities", "contacts"
  add_foreign_key "activities", "deals"
  add_foreign_key "activities", "users"
  add_foreign_key "contacts", "companies"
  add_foreign_key "deals", "companies"
  add_foreign_key "deals", "contacts"
  add_foreign_key "deals", "users", column: "owner_id"
end
