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

ActiveRecord::Schema.define(version: 20181119060114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checks", force: :cascade do |t|
    t.integer "team_id"
    t.integer "service_id"
    t.boolean "up"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "details"
    t.boolean "sla_violation"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "protocol"
    t.string "address_format"
    t.integer "port"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "arg1"
    t.string "arg2"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "number"
    t.string "password_digest"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "team_id"
    t.string "name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
