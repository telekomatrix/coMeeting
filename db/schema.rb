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

ActiveRecord::Schema.define(:version => 20120430111618) do

  create_table "action_items", :force => true do |t|
    t.integer  "participation_id",                    :null => false
    t.string   "todo"
    t.string   "deadline"
    t.boolean  "completed",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "associate_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["associate_id"], :name => "index_connections_on_associate_id"
  add_index "connections", ["user_id"], :name => "index_connections_on_user_id"

  create_table "meetings", :force => true do |t|
    t.string   "subject"
    t.string   "location"
    t.datetime "date"
    t.datetime "time"
    t.string   "time_zone"
    t.datetime "duration"
    t.text     "topics"
    t.string   "extra_info"
    t.text     "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meeting_id",                      :null => false
    t.string   "link"
    t.boolean  "is_creator",   :default => false, :null => false
    t.boolean  "is_admin",     :default => false, :null => false
    t.integer  "is_attending", :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["meeting_id"], :name => "index_participations_on_meeting_id"
  add_index "participations", ["user_id"], :name => "index_participations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
