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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130321182838) do

  create_table "codenames", :force => true do |t|
    t.string  "name"
    t.boolean "used", :default => false
  end

  add_index "codenames", ["name"], :name => "index_codenames_on_name", :unique => true

  create_table "positions", :force => true do |t|
    t.integer "company_uid"
    t.integer "uid"
    t.integer "user_id"
    t.string  "company_industry"
    t.string  "company_name"
    t.string  "company_type"
    t.string  "company_size"
    t.string  "title"
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "is_current"
    t.text    "summary"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "industry"
    t.string   "location_name"
    t.string   "country_code"
    t.string   "interest_level"
    t.string   "codename"
  end

  add_index "users", ["codename"], :name => "index_users_on_codename"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
