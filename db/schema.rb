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

ActiveRecord::Schema.define(version: 20180331185316) do

  create_table "follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "stylist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "municipalities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "order_num"
    t.integer  "prefecture_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "pictures_count", default: 0
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "rating",                        default: 1500, null: false
    t.integer  "user_id"
    t.integer  "win",                           default: 0,    null: false
    t.integer  "lose",                          default: 0,    null: false
    t.boolean  "picture_present",               default: true, null: false
    t.integer  "length"
    t.integer  "color"
    t.text     "text",            limit: 65535
    t.integer  "detail_count"
    t.integer  "likes_count",                   default: 0,    null: false
    t.integer  "gender",                                       null: false
    t.integer  "prefecture_id"
    t.integer  "municipality_id"
    t.index ["length"], name: "index_pictures_on_length", using: :btree
    t.index ["user_id"], name: "index_pictures_on_user_id", using: :btree
  end

  create_table "pictures_picture_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "genre"
    t.integer  "user_id"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prefectures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "order_num"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "pictures_count", default: 0
  end

  create_table "stylists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "shop_name"
    t.string   "shop_address"
    t.string   "shop_phone_number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["shop_address"], name: "index_stylists_on_shop_address", using: :btree
  end

  create_table "user_pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "picture_id"
    t.integer  "rating",     default: 1500, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "win",        default: 0,    null: false
    t.integer  "lose",       default: 0,    null: false
    t.datetime "voting_at"
    t.index ["user_id"], name: "index_user_pictures_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                                default: "",    null: false
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "admin",                                default: false, null: false
    t.string   "name"
    t.text     "profile",                limit: 65535
    t.integer  "role",                                 default: 1,     null: false
    t.string   "picture"
    t.string   "uid"
    t.string   "provider"
    t.string   "nickname"
    t.string   "location"
    t.string   "image"
    t.integer  "follower_count"
    t.integer  "follows_count"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
