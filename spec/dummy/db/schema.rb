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

ActiveRecord::Schema.define(version: 20221222113057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "another2_association_models", force: :cascade do |t|
    t.text "state"
    t.integer "test_model_id"
    t.integer "uid"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "another_association_models", force: :cascade do |t|
    t.integer "uid"
    t.integer "test_model_id"
    t.text "state"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "association2_models", force: :cascade do |t|
    t.text "state"
    t.integer "test_model_id"
    t.integer "uid"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "association_models", force: :cascade do |t|
    t.integer "test_model_id"
    t.integer "uid"
    t.text "text"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "test_models", force: :cascade do |t|
    t.text "text"
    t.integer "uid"
    t.text "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "enumerized"
    t.text "title"
    t.datetime "deleted_at"
  end

  create_table "tramway_users", force: :cascade do |t|
    t.text "email"
    t.text "password_digest"
    t.text "first_name"
    t.text "last_name"
    t.text "avatar"
    t.text "role"
    t.text "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
