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

ActiveRecord::Schema.define(:version => 20100503113238) do

  create_table "histories", :force => true do |t|
    t.integer  "todo_id"
    t.integer  "user_id"
    t.string   "event"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "inviter_id"
    t.string   "email"
    t.string   "name"
    t.string   "token"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shares", :force => true do |t|
    t.integer  "user_id"
    t.string   "tag"
    t.integer  "sharee_id"
    t.boolean  "can_complete"
    t.integer  "invite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_groups", :force => true do |t|
    t.string   "tag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "todos", :force => true do |t|
    t.string   "label"
    t.integer  "priority"
    t.datetime "completed_at"
    t.integer  "user_id"
    t.integer  "completed_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "due_date"
    t.datetime "waiting_since"
    t.datetime "starts_at"
    t.datetime "reminder_sent_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                :null => false
    t.string   "email",                                                :null => false
    t.string   "crypted_password",                                     :null => false
    t.string   "password_salt",                                        :null => false
    t.string   "persistence_token",                                    :null => false
    t.string   "single_access_token",                                  :null => false
    t.string   "perishable_token",                                     :null => false
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invite_id"
    t.boolean  "email_daily_summary",               :default => true
    t.datetime "daily_summary_sent_at"
    t.boolean  "email_summary_only_when_todos_due", :default => false
  end

end
