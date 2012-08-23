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

ActiveRecord::Schema.define(:version => 20120823150437) do

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "link"
    t.string   "logo"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "campground_features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "marker_icon"
    t.integer  "rank"
    t.string   "link_url"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "campground_features", ["category_id"], :name => "index_campground_features_on_category_id"

  create_table "campground_features_campgrounds", :id => false, :force => true do |t|
    t.integer "campground_id"
    t.integer "campground_feature_id"
  end

  create_table "campgrounds", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.integer  "park_id"
    t.boolean  "approved"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "campgrounds", ["park_id"], :name => "index_campgrounds_on_park_id"
  add_index "campgrounds", ["user_id"], :name => "index_campgrounds_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "visible"
    t.integer  "rank"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "link_url"
    t.integer  "rank"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "marker_icon"
  end

  add_index "features", ["category_id"], :name => "index_features_on_category_id"

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mapable_id"
    t.string   "mapable_type"
    t.string   "url"
    t.integer  "user_id"
    t.string   "map"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "maps", ["user_id"], :name => "index_maps_on_user_id"

  create_table "non_profit_partners", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "link"
    t.string   "logo"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "parks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "agency_id"
    t.integer  "acres"
    t.string   "county"
    t.string   "county_slug"
    t.integer  "non_profit_partner_id"
    t.text     "bounds"
    t.text     "slug"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "link"
    t.float    "min_longitude"
    t.float    "max_longitude"
    t.float    "min_latitude"
    t.float    "max_latitude"
  end

  add_index "parks", ["agency_id"], :name => "index_parks_on_agency_id"
  add_index "parks", ["non_profit_partner_id"], :name => "index_parks_on_non_profit_partner_id"

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "link"
    t.string   "logo"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "recent_activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "highlighted"
    t.text     "recent_news_text"
    t.string   "favorites_link1"
    t.string   "favorites_type1"
    t.string   "favorites_link2"
    t.string   "favorites_type2"
    t.string   "favorites_link3"
    t.string   "favorites_type3"
    t.string   "favorites_link4"
    t.string   "favorites_type4"
    t.string   "favorites_link5"
    t.string   "favorites_type5"
    t.text     "favorites_link1_text"
    t.text     "favorites_link2_text"
    t.text     "favorites_link3_text"
    t.text     "favorites_link4_text"
    t.text     "favorites_link5_text"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "trailhead_features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "marker_icon"
    t.integer  "rank"
    t.string   "link_url"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "trailhead_features", ["category_id"], :name => "index_trailhead_features_on_category_id"

  create_table "trailhead_features_trailheads", :id => false, :force => true do |t|
    t.integer "trailhead_id"
    t.integer "trailhead_feature_id"
  end

  create_table "trailheads", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.boolean  "rideshare"
    t.string   "zimride_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "approved"
    t.integer  "park_id"
  end

  add_index "trailheads", ["user_id"], :name => "index_trailheads_on_user_id"

  create_table "trip_features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "marker_icon"
    t.integer  "rank"
    t.string   "link_url"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "trip_features", ["category_id"], :name => "index_trip_features_on_category_id"

  create_table "user_profiles", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "url"
    t.text     "bio"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.string   "avatar"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "api_key"
    t.string   "api_secret"
    t.string   "organization_name"
    t.string   "organization_url"
    t.string   "organization_avatar"
    t.string   "signup_source"
    t.string   "website_address"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "username",               :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "django_password"
    t.boolean  "admin"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
