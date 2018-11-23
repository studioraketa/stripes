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

ActiveRecord::Schema.define(version: 2018_11_21_180304) do

  create_table "orders", force: :cascade do |t|
    t.string "uid", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripes_charges", force: :cascade do |t|
    t.integer "stripes_payment_id"
    t.string "identifier", limit: 255, null: false
    t.integer "status", default: 0, null: false
    t.string "source_uid"
    t.json "details"
    t.json "event_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripes_charges_on_identifier", unique: true
    t.index ["status"], name: "index_stripes_charges_on_status"
    t.index ["stripes_payment_id"], name: "index_stripes_charges_on_stripes_payment_id"
  end

  create_table "stripes_payments", force: :cascade do |t|
    t.integer "payment_type", default: 0
    t.integer "status", default: 0
    t.integer "amount", null: false
    t.string "currency", limit: 3, null: false
    t.json "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.index ["order_id"], name: "index_stripes_payments_on_order_id"
    t.index ["payment_type"], name: "index_stripes_payments_on_payment_type"
    t.index ["status"], name: "index_stripes_payments_on_status"
  end

  create_table "stripes_sources", force: :cascade do |t|
    t.integer "stripes_payment_id"
    t.string "identifier", limit: 255, null: false
    t.string "source_type", default: "", null: false
    t.integer "status", default: 0, null: false
    t.json "details"
    t.json "event_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_stripes_sources_on_identifier", unique: true
    t.index ["status"], name: "index_stripes_sources_on_status"
    t.index ["stripes_payment_id"], name: "index_stripes_sources_on_stripes_payment_id"
  end

end
