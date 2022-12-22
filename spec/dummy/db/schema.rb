# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_423_141_227) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'another2_association_models', force: :cascade do |t|
    t.text 'state'
    t.integer 'test_model_id'
    t.integer 'uid'
    t.text 'text'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'another_association_models', force: :cascade do |t|
    t.integer 'uid'
    t.integer 'test_model_id'
    t.text 'state'
    t.text 'text'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'association2_models', force: :cascade do |t|
    t.text 'state'
    t.integer 'test_model_id'
    t.integer 'uid'
    t.text 'text'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'association_models', force: :cascade do |t|
    t.integer 'test_model_id'
    t.integer 'uid'
    t.text 'text'
    t.text 'state'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'audits', force: :cascade do |t|
    t.integer 'auditable_id'
    t.string 'auditable_type'
    t.integer 'associated_id'
    t.string 'associated_type'
    t.integer 'user_id'
    t.string 'user_type'
    t.string 'username'
    t.string 'action'
    t.text 'audited_changes'
    t.integer 'version', default: 0
    t.string 'comment'
    t.string 'remote_address'
    t.string 'request_uuid'
    t.datetime 'created_at'
    t.index %w[associated_type associated_id], name: 'associated_index'
    t.index %w[auditable_type auditable_id version], name: 'auditable_index'
    t.index ['created_at'], name: 'index_audits_on_created_at'
    t.index ['request_uuid'], name: 'index_audits_on_request_uuid'
    t.index %w[user_id user_type], name: 'user_index'
  end

  create_table 'test_models', force: :cascade do |t|
    t.text 'text'
    t.integer 'uid'
    t.text 'state'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'enumerized'
    t.text 'title'
  end
end
