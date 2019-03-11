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

ActiveRecord::Schema.define(version: 2019_03_06_164316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "code"
    t.string "subject"
    t.string "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctor_patients", force: :cascade do |t|
    t.bigint "doctor_id"
    t.bigint "patient_id"
    t.boolean "praise", default: false
    t.string "status", default: "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_doctor_patients_on_doctor_id"
    t.index ["patient_id"], name: "index_doctor_patients_on_patient_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "user_id"
    t.string "doc_type"
    t.string "exam_type"
    t.string "doc_title"
    t.string "tags", default: [], array: true
    t.string "url"
    t.string "file_type"
    t.string "status", default: "active"
    t.integer "read_by"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "image_data"
    t.index ["topic_id"], name: "index_documents_on_topic_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_patients", force: :cascade do |t|
    t.bigint "family_id"
    t.bigint "patient_id"
    t.string "status", default: "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_family_patients_on_family_id"
    t.index ["patient_id"], name: "index_family_patients_on_patient_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "user_id"
    t.string "sc_type"
    t.string "sc_title"
    t.string "schedule"
    t.string "dosage"
    t.text "notes"
    t.date "date_start"
    t.date "date_end", default: "9999-12-31"
    t.string "status", default: "active"
    t.integer "read_by"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_schedules_on_topic_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "category_id"
    t.string "title"
    t.string "subcode"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_topics_on_category_id"
    t.index ["patient_id"], name: "index_topics_on_patient_id"
  end

  create_table "updates", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "user_id"
    t.text "diagnosis"
    t.string "next_steps", default: [], array: true
    t.string "topic_status", default: "active"
    t.integer "read_by"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_updates_on_topic_id"
    t.index ["user_id"], name: "index_updates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "photo"
    t.text "address"
    t.date "date_birth"
    t.string "identity_card"
    t.string "user_type"
    t.string "pat_blood"
    t.string "pat_pharma"
    t.string "pat_pharma_email"
    t.string "doc_number"
    t.string "doc_institutions", default: [], array: true
    t.string "doc_specialties", default: [], array: true
    t.string "status", default: "active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "documents", "topics"
  add_foreign_key "documents", "users"
  add_foreign_key "schedules", "topics"
  add_foreign_key "schedules", "users"
  add_foreign_key "updates", "topics"
  add_foreign_key "updates", "users"
end
