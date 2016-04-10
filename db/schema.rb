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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160410105712) do

  create_table "products", force: :cascade do |t|
    t.string   "asin",           limit: 255
    t.string   "isbn",           limit: 255
    t.string   "title",          limit: 255
    t.string   "binding",        limit: 255
    t.text     "product_url",    limit: 65535
    t.text     "image_small",    limit: 65535
    t.text     "image_medium",   limit: 65535
    t.text     "image_large",    limit: 65535
    t.decimal  "price",                        precision: 20, scale: 6
    t.string   "price_currency", limit: 255
    t.string   "group",          limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",    limit: 255
    t.string   "uid",         limit: 255
    t.string   "screen_name", limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "users", ["screen_name"], name: "index_users_on_screen_name", unique: true, using: :btree

end
