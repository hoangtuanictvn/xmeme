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

ActiveRecord::Schema.define(version: 2019_12_06_064155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_layouts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "width"
    t.integer "height"
    t.decimal "ratio"
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer "type"
    t.text "data"
    t.string "code"
    t.json "format"
    t.integer "render_status"
    t.string "url"
    t.text "thumb"
    t.decimal "width"
    t.decimal "height"
    t.boolean "is_template"
    t.integer "card_layout_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "music_resource_id"
    t.time "start_at"
    t.time "end_at"
    t.datetime "expired"
  end

  create_table "identifies", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "access_token"
    t.string "token_secret"
    t.datetime "expired"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "resource_type"
    t.string "data"
    t.string "container"
    t.string "format"
    t.integer "card_layout_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "file_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "uname"
    t.string "picture"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "first_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
