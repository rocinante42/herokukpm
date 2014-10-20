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

ActiveRecord::Schema.define(version: 20141020232717) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "enjoy_score"
    t.integer  "complete_score"
    t.integer  "pass_counter"
    t.integer  "fail_counter"
    t.integer  "weight"
    t.integer  "max_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities_games", id: false, force: true do |t|
    t.integer "activity_id"
    t.integer "game_id"
  end

  create_table "classrooms", force: true do |t|
    t.string   "name"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_activities", force: true do |t|
    t.integer  "status"
    t.integer  "score"
    t.boolean  "active"
    t.integer  "poset_id"
    t.integer  "activity_id"
    t.integer  "game_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_activities", ["activity_id"], name: "index_student_activities_on_activity_id"
  add_index "student_activities", ["game_id"], name: "index_student_activities_on_game_id"
  add_index "student_activities", ["poset_id"], name: "index_student_activities_on_poset_id"
  add_index "student_activities", ["student_id"], name: "index_student_activities_on_student_id"

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.string   "location"
    t.string   "primary_language"
    t.string   "game_language"
    t.boolean  "first_time"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["classroom_id"], name: "index_students_on_classroom_id"

end
