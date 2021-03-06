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

ActiveRecord::Schema.define(:version => 20130714054333) do

  create_table "arcs", :force => true do |t|
    t.string   "arc_type"
    t.integer  "from_node_id"
    t.integer  "to_node_id"
    t.integer  "transit_time"
    t.integer  "train_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "node_details", :force => true do |t|
    t.integer  "station_num"
    t.string   "station_name"
    t.integer  "event_time"
    t.integer  "original_event_time"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "nodes", :force => true do |t|
    t.integer  "station_num"
    t.integer  "event_time"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "train_routes", :force => true do |t|
    t.integer  "train_number"
    t.integer  "route_point_seq"
    t.integer  "station_num"
    t.string   "station_name"
    t.integer  "arrive_time_hhhmm"
    t.integer  "depart_time_hhhmm"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "trains", :force => true do |t|
    t.integer  "train_number"
    t.integer  "loop_id"
    t.string   "train_category",  :default => "Short Distance", :null => false
    t.boolean  "operates_day_1",  :default => false,            :null => false
    t.boolean  "operates_day_2",  :default => false,            :null => false
    t.boolean  "operates_day_3",  :default => false,            :null => false
    t.boolean  "operates_day_4",  :default => false,            :null => false
    t.boolean  "operates_day_5",  :default => false,            :null => false
    t.boolean  "operates_day_6",  :default => false,            :null => false
    t.boolean  "operates_day_7",  :default => false,            :null => false
    t.boolean  "operates_day_8",  :default => false,            :null => false
    t.boolean  "operates_day_9",  :default => false,            :null => false
    t.boolean  "operates_day_10", :default => false,            :null => false
    t.boolean  "operates_day_11", :default => false,            :null => false
    t.boolean  "operates_day_12", :default => false,            :null => false
    t.boolean  "operates_day_13", :default => false,            :null => false
    t.boolean  "operates_day_14", :default => false,            :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

end
