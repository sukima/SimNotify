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

ActiveRecord::Schema.define(:version => 20100710184143) do

  create_table "equipment_suggestions", :force => true do |t|
    t.string "title"
    t.text   "description"
  end

  create_table "events", :force => true do |t|
    t.string   "location",                         :null => false
    t.text     "benefit",                          :null => false
    t.text     "notes"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "live_in",       :default => false
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
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
  end

  create_table "manikins", :force => true do |t|
    t.string  "name"
    t.string  "serial_number"
    t.string  "sim_type"
    t.boolean "oos"
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
  end

end
