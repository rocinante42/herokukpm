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

ActiveRecord::Schema.define(version: 20141217222846) do

  create_table "bubble_games", force: true do |t|
    t.integer  "bubble_id"
    t.integer  "game_id"
    t.string   "skin"
    t.string   "game_params"
    t.string   "scoring_params"
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
  end

  create_table "bubble_groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "full_poset_id"
    t.integer  "forward_poset_id"
    t.integer  "backward_poset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "classrooms", force: true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edges", force: true do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.integer  "poset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "posets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "fail_threshold", default: 2, null: false
    t.integer  "pass_threshold", default: 2, null: false
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "triggers", force: true do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
