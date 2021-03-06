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

ActiveRecord::Schema.define(version: 20151216102419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bubble_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bubble_categories_classroom_types", id: false, force: true do |t|
    t.integer "bubble_category_id", null: false
    t.integer "classroom_type_id",  null: false
  end

  create_table "bubble_games", force: true do |t|
    t.integer  "bubble_id"
    t.integer  "game_id"
    t.string   "skin"
    t.text     "game_params"
    t.text     "scoring_params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bubble_group_statuses", force: true do |t|
    t.integer  "kid_id"
    t.integer  "bubble_group_id"
    t.integer  "poset_id"
    t.integer  "pass_counter",    default: 0, null: false
    t.integer  "fail_counter",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active",          default: 0
    t.integer  "general_id"
    t.integer  "classroom_id"
    t.integer  "time_limit"
  end

  add_index "bubble_group_statuses", ["classroom_id"], name: "index_bubble_group_statuses_on_classroom_id", using: :btree

  create_table "bubble_groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "full_poset_id"
    t.integer  "forward_poset_id"
    t.integer  "backward_poset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bubble_groups_classroom_types", id: false, force: true do |t|
    t.integer "bubble_group_id"
    t.integer "classroom_type_id"
  end

  add_index "bubble_groups_classroom_types", ["bubble_group_id"], name: "index_bubble_groups_classroom_types_on_bubble_group_id", using: :btree
  add_index "bubble_groups_classroom_types", ["classroom_type_id"], name: "index_bubble_groups_classroom_types_on_classroom_type_id", using: :btree

  create_table "bubble_statuses", force: true do |t|
    t.integer  "bubble_group_status_id"
    t.integer  "bubble_id"
    t.boolean  "passed"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bubbles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "bubble_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bubble_category_id"
  end

  add_index "bubbles", ["bubble_category_id"], name: "index_bubbles_on_bubble_category_id", using: :btree

  create_table "classroom_types", force: true do |t|
    t.string   "type_name"
    t.string   "type_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classrooms", force: true do |t|
    t.string   "name"
    t.integer  "classroom_type_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classrooms", ["classroom_type_id"], name: "index_classrooms_on_classroom_type_id", using: :btree

  create_table "edges", force: true do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.integer  "poset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "family_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "kid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "family_relationships", ["kid_id"], name: "index_family_relationships_on_kid_id", using: :btree
  add_index "family_relationships", ["user_id"], name: "index_family_relationships_on_user_id", using: :btree

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kid_activities", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bubble_group_status_id"
  end

  create_table "kids", force: true do |t|
    t.integer  "login_id"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.string   "primary_language"
    t.string   "access_token"
    t.datetime "token_expiration_time"
  end

  create_table "posets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "fail_threshold", default: 2, null: false
    t.integer  "pass_threshold", default: 2, null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bubble_id"
    t.integer  "bubble_group_id"
  end

  create_table "users", force: true do |t|
    t.integer  "role_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "direct_phone"
    t.string   "alternate_phone"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "school_id"
    t.integer  "classroom_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["classroom_id"], name: "index_users_on_classroom_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["school_id"], name: "index_users_on_school_id", using: :btree

end
