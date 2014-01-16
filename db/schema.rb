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

ActiveRecord::Schema.define(version: 20130728222334) do

  create_table "problems", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "test_examples"
    t.string   "source"
    t.text     "copyright"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["user_id"], name: "index_problems_on_user_id"

  create_table "submissions", force: true do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.string   "language"
    t.text     "code"
    t.string   "judge_status"
    t.text     "judge_result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "submissions", ["judge_status"], name: "index_submissions_on_judge_status"
  add_index "submissions", ["problem_id"], name: "index_submissions_on_problem_id"
  add_index "submissions", ["user_id", "judge_status"], name: "index_submissions_on_user_id_and_judge_status"
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nick"
    t.string   "image_url"
    t.string   "auth_token"
    t.string   "auth_secret"
    t.boolean  "staff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["nick"], name: "index_users_on_nick"
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid"

end
