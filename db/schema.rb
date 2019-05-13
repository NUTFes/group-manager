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

ActiveRecord::Schema.define(version: 2019_05_12_080635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "assign_group_places", id: :serial, force: :cascade do |t|
    t.integer "place_order_id", null: false
    t.integer "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_assign_group_places_on_place_id"
    t.index ["place_order_id"], name: "index_assign_group_places_on_place_order_id"
  end

  create_table "assign_rental_items", id: :serial, force: :cascade do |t|
    t.integer "rental_order_id", null: false
    t.integer "rentable_item_id", null: false
    t.integer "num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rentable_item_id"], name: "index_assign_rental_items_on_rentable_item_id"
    t.index ["rental_order_id"], name: "index_assign_rental_items_on_rental_order_id"
  end

  create_table "assign_stages", id: :serial, force: :cascade do |t|
    t.integer "stage_order_id"
    t.integer "stage_id"
    t.string "time_point_start"
    t.string "time_point_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_assign_stages_on_stage_id"
    t.index ["stage_order_id"], name: "index_assign_stages_on_stage_order_id"
  end

  create_table "config_user_permissions", id: :serial, force: :cascade do |t|
    t.string "form_name", null: false
    t.boolean "is_accepting", default: false
    t.boolean "is_only_show", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "panel_partial", null: false
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.string "name_ja"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_categories", id: :serial, force: :cascade do |t|
    t.string "name_ja"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "name", null: false
    t.integer "student_id", null: false
    t.boolean "duplication"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_employees_on_group_id"
  end

  create_table "fes_dates", id: :serial, force: :cascade do |t|
    t.integer "days_num"
    t.string "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "day", null: false
    t.integer "fes_year_id"
    t.index ["fes_year_id"], name: "index_fes_dates_on_fes_year_id"
  end

  create_table "fes_years", id: :serial, force: :cascade do |t|
    t.integer "fes_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_products", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "name", null: false
    t.integer "first_day_num", default: 0, null: false
    t.boolean "is_cooking", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "second_day_num", default: 0
    t.index ["group_id"], name: "index_food_products_on_group_id"
  end

  create_table "grades", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_categories", id: :serial, force: :cascade do |t|
    t.string "name_ja"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_manager_common_options", id: :serial, force: :cascade do |t|
    t.string "cooking_start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_of_stool_test"
    t.string "rental_item_day"
    t.string "rental_item_time"
    t.string "return_item_day"
    t.string "return_item_time"
    t.string "order_deadline"
  end

  create_table "group_project_names", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.string "project_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_project_names_on_group_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "group_category_id"
    t.integer "user_id"
    t.text "activity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fes_year_id"
    t.index ["fes_year_id"], name: "index_groups_on_fes_year_id"
    t.index ["group_category_id"], name: "index_groups_on_group_category_id"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "inside_or_outsides", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "place_allow_lists", id: :serial, force: :cascade do |t|
    t.integer "place_id", null: false
    t.integer "group_category_id", null: false
    t.boolean "enable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_category_id"], name: "index_place_allow_lists_on_group_category_id"
    t.index ["place_id", "group_category_id"], name: "index_place_allow_lists_on_place_id_and_group_category_id", unique: true
    t.index ["place_id"], name: "index_place_allow_lists_on_place_id"
  end

  create_table "place_orders", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "first"
    t.integer "second"
    t.integer "third"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "remark"
    t.bigint "inside_or_outside_id"
    t.index ["group_id"], name: "index_place_orders_on_group_id"
    t.index ["inside_or_outside_id"], name: "index_place_orders_on_inside_or_outside_id"
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.string "name_ja"
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "power_orders", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "item", null: false
    t.integer "power"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manufacturer", null: false
    t.string "model", null: false
    t.string "item_url"
    t.index ["group_id"], name: "index_power_orders_on_group_id"
  end

  create_table "purchase_lists", id: :serial, force: :cascade do |t|
    t.integer "food_product_id", null: false
    t.integer "shop_id", null: false
    t.integer "fes_date_id", null: false
    t.boolean "is_fresh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "items", null: false
    t.index ["fes_date_id"], name: "index_purchase_lists_on_fes_date_id"
    t.index ["food_product_id"], name: "index_purchase_lists_on_food_product_id"
    t.index ["shop_id"], name: "index_purchase_lists_on_shop_id"
  end

  create_table "rentable_items", id: :serial, force: :cascade do |t|
    t.integer "stocker_item_id"
    t.integer "stocker_place_id"
    t.integer "max_num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stocker_item_id"], name: "index_rentable_items_on_stocker_item_id"
    t.index ["stocker_place_id"], name: "index_rentable_items_on_stocker_place_id"
  end

  create_table "rental_item_allow_lists", id: :serial, force: :cascade do |t|
    t.integer "rental_item_id"
    t.integer "group_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_category_id"], name: "index_rental_item_allow_lists_on_group_category_id"
    t.index ["rental_item_id", "group_category_id"], name: "index_rental_item_allow_unique", unique: true
    t.index ["rental_item_id"], name: "index_rental_item_allow_lists_on_rental_item_id"
  end

  create_table "rental_items", id: :serial, force: :cascade do |t|
    t.string "name_ja", null: false
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_rentable", default: true, null: false
  end

  create_table "rental_orders", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "rental_item_id"
    t.integer "num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_rental_orders_on_group_id"
    t.index ["rental_item_id"], name: "index_rental_orders_on_rental_item_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "tel", null: false
    t.string "time_weekdays"
    t.string "time_sat"
    t.string "time_sun"
    t.string "time_holidays"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kana"
    t.boolean "is_closed_sun", default: false
    t.boolean "is_closed_mon", default: false
    t.boolean "is_closed_tue", default: false
    t.boolean "is_closed_wed", default: false
    t.boolean "is_closed_thu", default: false
    t.boolean "is_closed_fri", default: false
    t.boolean "is_closed_sat", default: false
    t.boolean "is_closed_holiday", default: false
  end

  create_table "stage_common_options", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.boolean "own_equipment"
    t.boolean "bgm"
    t.boolean "camera_permittion"
    t.boolean "loud_sound"
    t.text "stage_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_stage_common_options_on_group_id"
  end

  create_table "stage_orders", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.boolean "is_sunny"
    t.integer "fes_date_id"
    t.integer "stage_first"
    t.integer "stage_second"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "use_time_interval", default: ""
    t.string "prepare_time_interval", default: ""
    t.string "cleanup_time_interval", default: ""
    t.string "prepare_start_time", default: ""
    t.string "performance_start_time", default: ""
    t.string "performance_end_time", default: ""
    t.string "cleanup_end_time", default: ""
    t.index ["fes_date_id"], name: "index_stage_orders_on_fes_date_id"
    t.index ["group_id"], name: "index_stage_orders_on_group_id"
  end

  create_table "stages", id: :serial, force: :cascade do |t|
    t.string "name_ja", null: false
    t.string "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable_sunny", default: false
    t.boolean "enable_rainy", default: false
  end

  create_table "stocker_items", id: :serial, force: :cascade do |t|
    t.integer "rental_item_id"
    t.integer "stocker_place_id"
    t.integer "num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_item_id"], name: "index_stocker_items_on_rental_item_id"
    t.index ["stocker_place_id"], name: "index_stocker_items_on_stocker_place_id"
  end

  create_table "stocker_places", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_available_fesdate", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_reps", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "name_ja", null: false
    t.string "name_en", null: false
    t.integer "department_id", null: false
    t.integer "grade_id", null: false
    t.string "tel", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_sub_reps_on_department_id"
    t.index ["grade_id"], name: "index_sub_reps_on_grade_id"
    t.index ["group_id"], name: "index_sub_reps_on_group_id"
  end

  create_table "user_details", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name_ja"
    t.string "name_en"
    t.integer "department_id"
    t.integer "grade_id"
    t.string "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_user_details_on_department_id"
    t.index ["grade_id"], name: "index_user_details_on_grade_id"
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_detail_id"
    t.boolean "get_notice", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_detail_id"], name: "index_users_on_user_detail_id"
  end

  add_foreign_key "assign_group_places", "place_orders"
  add_foreign_key "assign_group_places", "places"
  add_foreign_key "assign_rental_items", "rentable_items"
  add_foreign_key "assign_rental_items", "rental_orders"
  add_foreign_key "assign_stages", "stage_orders"
  add_foreign_key "assign_stages", "stages"
  add_foreign_key "employees", "groups"
  add_foreign_key "fes_dates", "fes_years"
  add_foreign_key "food_products", "groups"
  add_foreign_key "group_project_names", "groups"
  add_foreign_key "groups", "fes_years"
  add_foreign_key "groups", "group_categories"
  add_foreign_key "groups", "users"
  add_foreign_key "place_allow_lists", "group_categories"
  add_foreign_key "place_allow_lists", "places"
  add_foreign_key "place_orders", "groups"
  add_foreign_key "place_orders", "inside_or_outsides"
  add_foreign_key "power_orders", "groups"
  add_foreign_key "purchase_lists", "fes_dates"
  add_foreign_key "purchase_lists", "food_products"
  add_foreign_key "purchase_lists", "shops"
  add_foreign_key "rentable_items", "stocker_items"
  add_foreign_key "rentable_items", "stocker_places"
  add_foreign_key "rental_item_allow_lists", "group_categories"
  add_foreign_key "rental_item_allow_lists", "rental_items"
  add_foreign_key "rental_orders", "groups"
  add_foreign_key "rental_orders", "rental_items"
  add_foreign_key "stage_common_options", "groups"
  add_foreign_key "stage_orders", "fes_dates"
  add_foreign_key "stage_orders", "groups"
  add_foreign_key "stocker_items", "rental_items"
  add_foreign_key "stocker_items", "stocker_places"
  add_foreign_key "sub_reps", "departments"
  add_foreign_key "sub_reps", "grades"
  add_foreign_key "sub_reps", "groups"
  add_foreign_key "user_details", "departments"
  add_foreign_key "user_details", "grades"
  add_foreign_key "user_details", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "user_details"
end
