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

ActiveRecord::Schema.define(version: 20151122194413) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "article_carousels", force: :cascade do |t|
    t.integer "article_id",     null: false
    t.integer "carousel_order", null: false
  end

  create_table "article_translations", force: :cascade do |t|
    t.integer  "article_id",             null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      limit: 255
    t.text     "body"
  end

  add_index "article_translations", ["article_id"], name: "index_article_translations_on_article_id"
  add_index "article_translations", ["locale"], name: "index_article_translations_on_locale"

  create_table "articles", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "body"
    t.string   "author",      limit: 255
    t.string   "image",       limit: 255
    t.integer  "category_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",               default: false
    t.integer  "coach_id"
  end

  add_index "articles", ["team_id"], name: "index_articles_on_team_id"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "coach_translations", force: :cascade do |t|
    t.integer  "coach_id",               null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "bio"
  end

  add_index "coach_translations", ["coach_id"], name: "index_coach_translations_on_coach_id"
  add_index "coach_translations", ["locale"], name: "index_coach_translations_on_locale"

  create_table "coaches", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",      limit: 255
  end

  add_index "coaches", ["email"], name: "index_coaches_on_email", unique: true

  create_table "contact_translations", force: :cascade do |t|
    t.integer  "contact_id",                null: false
    t.string   "locale",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "club_position", limit: 255
    t.text     "description"
    t.text     "bio"
  end

  add_index "contact_translations", ["contact_id"], name: "index_contact_translations_on_contact_id"
  add_index "contact_translations", ["locale"], name: "index_contact_translations_on_locale"

  create_table "contacts", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.text     "bio"
    t.string   "club_position", limit: 255
    t.text     "description"
    t.integer  "category"
    t.integer  "row_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",         limit: 255
  end

  create_table "event_details", force: :cascade do |t|
    t.datetime "start"
    t.integer  "duration"
    t.integer  "location_id"
    t.integer  "event_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_groups", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "groups",                      default: 0
    t.string   "boys_age_range",  limit: 255
    t.string   "girls_age_range", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_translations", force: :cascade do |t|
    t.integer  "event_id",               null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "heading",    limit: 255
    t.text     "body"
    t.text     "tout"
  end

  add_index "event_translations", ["event_id"], name: "index_event_translations_on_event_id"
  add_index "event_translations", ["locale"], name: "index_event_translations_on_locale"

  create_table "events", force: :cascade do |t|
    t.integer  "type",                   default: 0, null: false
    t.string   "heading",    limit: 255
    t.text     "body"
    t.text     "tout"
    t.integer  "status",                 default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "club",       limit: 255
    t.string   "rain_line",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.decimal  "lat",                    precision: 15, scale: 10
    t.decimal  "lng",                    precision: 15, scale: 10
    t.string   "address",    limit: 255
    t.string   "type",       limit: 255,                           default: "Field"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_level_translations", force: :cascade do |t|
    t.integer  "team_level_id",             null: false
    t.string   "locale",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",          limit: 255
  end

  add_index "team_level_translations", ["locale"], name: "index_team_level_translations_on_locale"
  add_index "team_level_translations", ["team_level_id"], name: "index_team_level_translations_on_team_level_id"

  create_table "team_levels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "year"
    t.integer  "gender_id",        limit: 255
    t.string   "name",             limit: 255
    t.integer  "coach_id"
    t.integer  "team_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",            limit: 255
    t.string   "teamsnap_team_id", limit: 255
  end

  create_table "tryout_registrations", force: :cascade do |t|
    t.string   "first",                     limit: 255
    t.string   "last",                      limit: 255
    t.string   "home_address",              limit: 255
    t.date     "birthdate"
    t.integer  "age"
    t.integer  "gender"
    t.string   "previous_team",             limit: 255
    t.string   "parent1_first",             limit: 255
    t.string   "parent1_last",              limit: 255
    t.string   "parent1_cell",              limit: 255
    t.string   "parent1_email",             limit: 255
    t.string   "parent2_first",             limit: 255
    t.string   "parent2_last",              limit: 255
    t.string   "parent2_cell",              limit: 255
    t.string   "parent2_email",             limit: 255
    t.string   "completed_by",              limit: 255
    t.string   "relationship",              limit: 255
    t.boolean  "waiver"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city",                      limit: 255
    t.string   "playerEmail"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "parent1_homePhone"
    t.string   "parent2_homePhone"
    t.string   "parent1_businessPhone"
    t.string   "parent2_businessPhone"
    t.string   "emergency_contact1_name"
    t.string   "emergency_contact1_phone1"
    t.string   "emergency_contact1_phone2"
    t.string   "emergency_contact2_name"
    t.string   "emergency_contact2_phone1"
    t.string   "emergency_contact2_phone2"
    t.string   "alergies"
    t.string   "medical_conditions"
    t.string   "physician_name"
    t.string   "physician_phone1"
    t.string   "physician_phone2"
    t.string   "insurance_name"
    t.string   "insurance_phone"
    t.string   "policy_holder"
    t.string   "policy_number"
  end

  create_table "web_part_translations", force: :cascade do |t|
    t.integer  "web_part_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html"
  end

  add_index "web_part_translations", ["locale"], name: "index_web_part_translations_on_locale"
  add_index "web_part_translations", ["web_part_id"], name: "index_web_part_translations_on_web_part_id"

  create_table "web_parts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "html",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
  end

  add_index "web_parts", ["page_id"], name: "index_web_parts_on_page_id"

end
