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

ActiveRecord::Schema.define(:version => 20120526222853) do

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags_todos", :force => true do |t|
    t.integer "todo_id"
    t.integer "tag_id"
  end

  add_index "tags_todos", ["tag_id", "todo_id"], :name => "index_tags_todos_on_tag_id_and_todo_id"
  add_index "tags_todos", ["todo_id", "tag_id"], :name => "index_tags_todos_on_todo_id_and_tag_id"

  create_table "todo_contexts", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "todo_contexts_todos", :force => true do |t|
    t.integer "todo_id"
    t.integer "todo_context_id"
  end

  add_index "todo_contexts_todos", ["todo_context_id", "todo_id"], :name => "index_todo_contexts_todos_on_todo_context_id_and_todo_id"
  add_index "todo_contexts_todos", ["todo_id", "todo_context_id"], :name => "index_todo_contexts_todos_on_todo_id_and_todo_context_id"

  create_table "todos", :force => true do |t|
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "completed",      :default => false
    t.datetime "completed_time"
    t.datetime "deleted_at"
    t.integer  "project_id"
  end

  create_table "users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username",               :default => "", :null => false
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
