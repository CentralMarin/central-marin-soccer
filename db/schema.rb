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

ActiveRecord::Schema.define(version: 20150206214053) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "article_carousels", force: true do |t|
    t.integer "article_id",     null: false
    t.integer "carousel_order", null: false
  end

  create_table "article_translations", force: true do |t|
    t.integer  "article_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
  end

  add_index "article_translations", ["article_id"], name: "index_article_translations_on_article_id"
  add_index "article_translations", ["locale"], name: "index_article_translations_on_locale"

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "author"
    t.string   "image"
    t.integer  "category_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   default: false
    t.integer  "coach_id"
  end

  add_index "articles", ["team_id"], name: "index_articles_on_team_id"

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "coach_translations", force: true do |t|
    t.integer  "coach_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bio"
  end

  add_index "coach_translations", ["coach_id"], name: "index_coach_translations_on_coach_id"
  add_index "coach_translations", ["locale"], name: "index_coach_translations_on_locale"

  create_table "coaches", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "coaches", ["email"], name: "index_coaches_on_email", unique: true

  create_table "fields", force: true do |t|
    t.string   "name"
    t.string   "club"
    t.string   "rain_line"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.decimal  "lat",        precision: 15, scale: 10
    t.decimal  "lng",        precision: 15, scale: 10
    t.string   "address"
  end

  create_table "team_level_translations", force: true do |t|
    t.integer  "team_level_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "team_level_translations", ["locale"], name: "index_team_level_translations_on_locale"
  add_index "team_level_translations", ["team_level_id"], name: "index_team_level_translations_on_team_level_id"

  create_table "team_levels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.integer  "year"
    t.integer  "gender_id",        limit: 255
    t.string   "name"
    t.integer  "coach_id"
    t.integer  "team_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "teamsnap_team_id"
  end

  create_table "tryout_registrations", force: true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "home_address"
    t.string   "home_phone"
    t.date     "birthdate"
    t.integer  "age"
    t.integer  "gender"
    t.string   "previous_team"
    t.string   "parent1_first"
    t.string   "parent1_last"
    t.string   "parent1_cell"
    t.string   "parent1_email"
    t.string   "parent2_first"
    t.string   "parent2_last"
    t.string   "parent2_cell"
    t.string   "parent2_email"
    t.string   "completed_by"
    t.string   "relationship"
    t.boolean  "waiver"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
  end

  create_table "tryout_type_translations", force: true do |t|
    t.integer  "tryout_type_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.text     "body"
  end

  add_index "tryout_type_translations", ["locale"], name: "index_tryout_type_translations_on_locale"
  add_index "tryout_type_translations", ["tryout_type_id"], name: "index_tryout_type_translations_on_tryout_type_id"

  create_table "tryout_types", force: true do |t|
    t.string   "name"
    t.string   "header"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tryouts", force: true do |t|
    t.integer  "gender_id"
    t.integer  "age"
    t.datetime "start"
    t.integer  "field_id"
    t.boolean  "is_makeup"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
    t.integer  "tryout_type_id"
    t.string   "location"
  end

  create_table "web_part_translations", force: true do |t|
    t.integer  "web_part_id",             null: false
    t.string   "locale",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html",        limit: 255
  end

  add_index "web_part_translations", ["locale"], name: "index_web_part_translations_on_locale"
  add_index "web_part_translations", ["web_part_id"], name: "index_web_part_translations_on_web_part_id"

  create_table "web_parts", force: true do |t|
    t.string   "name"
    t.text     "html",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
