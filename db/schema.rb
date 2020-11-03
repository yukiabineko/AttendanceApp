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

ActiveRecord::Schema.define(version: 2020_10_31_134031) do

  create_table "attendances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overtime"
    t.boolean "tommorow_check", default: false
    t.string "work_contents"
    t.string "superior_name"
    t.boolean "change", default: false
    t.integer "permit", default: 0
    t.datetime "request_startedtime"
    t.datetime "request_finishedtime"
    t.string "edit_superior_name"
    t.boolean "edit_check", default: false
    t.integer "edit_permit", default: 0
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.string "start_work_time"
    t.string "finish_work_time"
    t.string "department"
    t.integer "employee_number"
    t.integer "uid"
    t.string "basic_work_time"
    t.boolean "superior", default: false
  end

end
