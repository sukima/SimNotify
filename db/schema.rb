# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110808184134) do

  create_table "assets", :force => true do |t|
    t.string   "session_asset_file_name"
    t.string   "session_asset_content_type"
    t.integer  "session_asset_file_size"
    t.datetime "session_asset_updated_at"
    t.integer  "instructor_id"
  end

  create_table "assets_events", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "event_id"
  end

  create_table "equipment_suggestions", :force => true do |t|
    t.string "title"
    t.text   "description"
  end

  create_table "events", :force => true do |t|
    t.string   "location",                                :null => false
    t.text     "benefit",                                 :null => false
    t.text     "notes"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "live_in",              :default => false
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "submitted",            :default => false
    t.boolean  "approved",             :default => false
    t.integer  "technician_id"
    t.integer  "facility_id"
    t.datetime "notification_sent_on"
  end

  create_table "events_instructors", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "instructor_id"
  end

  create_table "facilities", :force => true do |t|
    t.string   "name",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agenda_color"
  end

  create_table "instructors", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "email",                                :null => false
    t.string   "office"
    t.string   "phone"
    t.boolean  "admin",             :default => false
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.boolean  "notify_recipient",  :default => false
    t.string   "gui_theme"
    t.boolean  "new_user",          :default => true
    t.boolean  "is_tech",           :default => false
    t.integer  "facility_id"
    t.boolean  "active",            :default => true
  end

  create_table "location_suggestions", :force => true do |t|
    t.string "location", :null => false
  end

  create_table "manikin_req_types", :force => true do |t|
    t.string "req_type", :null => false
  end

  create_table "manikins", :force => true do |t|
    t.string  "name"
    t.string  "serial_number"
    t.string  "sim_type"
    t.boolean "oos"
    t.integer "manikin_req_type_id"
  end

  create_table "options", :force => true do |t|
    t.string "name",  :null => false
    t.string "value"
  end

  create_table "program_submissions", :force => true do |t|
    t.string   "name"
    t.string   "job_title"
    t.string   "department"
    t.string   "phone"
    t.string   "email"
    t.text     "summery"
    t.text     "outcome"
    t.boolean  "supervisor_notified"
    t.string   "proximity"
    t.text     "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "benifit"
    t.integer  "contact_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenario_templates", :force => true do |t|
    t.string   "title",            :null => false
    t.text     "equipment"
    t.boolean  "staff_support"
    t.boolean  "moulage"
    t.text     "notes"
    t.text     "support_material"
    t.text     "description"
    t.boolean  "video"
    t.boolean  "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manikin_id"
  end

  create_table "scenarios", :force => true do |t|
    t.text    "equipment"
    t.boolean "staff_support"
    t.boolean "moulage"
    t.text    "notes"
    t.text    "support_material"
    t.text    "description"
    t.boolean "video"
    t.boolean "mobile"
    t.integer "event_id"
    t.integer "manikin_id"
    t.integer "manikin_req_type_id"
    t.text    "title",               :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "special_events", :force => true do |t|
    t.string   "title"
    t.text     "notes"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "all_day",       :default => false
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_type"
  end

end
