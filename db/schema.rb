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

ActiveRecord::Schema.define(:version => 20150606074740) do

  create_table "bank_details", :force => true do |t|
    t.string   "ac_no"
    t.string   "name"
    t.string   "ifsc_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customer_bank_details", :force => true do |t|
    t.integer  "customer_id",    :precision => 38, :scale => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "bank_detail_id", :precision => 38, :scale => 0
  end

  create_table "customers", :force => true do |t|
    t.string   "aadhaar_no"
    t.string   "email"
    t.string   "phone_no"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "merchants", :force => true do |t|
    t.integer  "user_id",    :precision => 38, :scale => 0
    t.string   "phone_no"
    t.string   "name"
    t.string   "tan_no"
    t.string   "address"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "refunds", :force => true do |t|
    t.integer  "merchant_id",       :precision => 38, :scale => 0
    t.integer  "customer_id",       :precision => 38, :scale => 0
    t.integer  "bank_detail_id",    :precision => 38, :scale => 0
    t.decimal  "amount"
    t.string   "state"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.boolean  "customer_in_store", :precision => 1,  :scale => 0, :default => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "refund_id",  :precision => 38, :scale => 0
    t.string   "status"
    t.string   "txn_ref_no"
    t.string   "txn_type"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                                :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128,                                :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "i_users_reset_password_token", :unique => true

end
