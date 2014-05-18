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

ActiveRecord::Schema.define(version: 20140518223705) do

  create_table "accounts", force: true do |t|
    t.string   "shopify_account_url"
    t.string   "shopify_api_key"
    t.string   "shopify_password"
    t.string   "shopify_shared_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "shopify_product_id"
    t.datetime "last_shopify_sync"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", force: true do |t|
    t.integer  "product_id"
    t.integer  "shopify_variant_id"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "sku"
    t.string   "barcode"
    t.float    "price"
    t.datetime "last_shopify_sync"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variants", ["product_id"], name: "index_variants_on_product_id"

end
