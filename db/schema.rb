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

ActiveRecord::Schema[7.0].define(version: 2022_12_19_165238) do
  create_table "periods", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "sleep_time", null: false
    t.datetime "wake_up_time"
    t.integer "duration", limit: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["duration"], name: "index_periods_on_duration"
    t.index ["sleep_time"], name: "index_periods_on_sleep_time"
    t.index ["user_id"], name: "index_periods_on_user_id"
    t.index ["wake_up_time"], name: "index_periods_on_wake_up_time"
  end

  create_table "relations", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_relations_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_relations_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_relations_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
