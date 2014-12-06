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

ActiveRecord::Schema.define(version: 20141005121340) do

  create_table "submissions", force: true do |t|
    t.integer  "user_id",                        null: false
    t.integer  "task_id",                        null: false
    t.text     "code"
    t.string   "lang",                           null: false
    t.string   "result",     default: "Testing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_samples", force: true do |t|
    t.integer  "task_id",    null: false
    t.string   "input",      null: false
    t.string   "output",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_tags", force: true do |t|
    t.integer  "task_id",    null: false
    t.string   "title_rus",  null: false
    t.string   "title_eng",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.integer  "task_id",      null: false
    t.string   "title",        null: false
    t.string   "time_limit",   null: false
    t.string   "memory_limit", null: false
    t.string   "statement",    null: false
    t.string   "input",        null: false
    t.string   "output",       null: false
    t.integer  "difficulty",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "uid",        null: false
    t.string   "provider",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
