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

ActiveRecord::Schema.define(version: 20140520122716) do

  create_table "accounts", force: true do |t|
    t.string   "shopify_account_url"
    t.string   "shopify_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shopify_shop_id"
    t.string   "shopify_shop_name"
    t.string   "shop_owner"
    t.string   "email"
    t.boolean  "paid"
    t.integer  "charge_id"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email"
  add_index "accounts", ["shopify_account_url"], name: "index_accounts_on_shopify_account_url"

  create_table "contests", force: true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "max_results"
    t.integer  "order_id"
    t.string   "product_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "contests", ["account_id"], name: "index_contests_on_account_id"
  add_index "contests", ["order_id"], name: "index_contests_on_order_id"

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "variant_id"
    t.integer  "shopify_product_id"
    t.integer  "shopify_variant_id"
    t.float    "unit_price"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"
  add_index "order_items", ["shopify_variant_id"], name: "index_order_items_on_shopify_variant_id"
  add_index "order_items", ["variant_id"], name: "index_order_items_on_variant_id"

  create_table "orders", force: true do |t|
    t.string   "number"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "shopify_order_id"
    t.datetime "order_date"
    t.float    "total"
    t.integer  "line_item_count"
    t.string   "financial_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "orders", ["account_id"], name: "index_orders_on_account_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.integer  "shopify_product_id"
    t.datetime "last_shopify_sync"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "products", ["account_id"], name: "index_products_on_account_id"

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
