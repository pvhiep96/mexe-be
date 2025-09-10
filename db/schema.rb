# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_09_10_025723) do
  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "client_name"
    t.string "client_phone"
    t.text "client_address"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "article_images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.string "image_url", null: false
    t.string "alt_text"
    t.string "caption"
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_images_on_article_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.text "content", null: false
    t.string "featured_image"
    t.string "author", default: "Mexe Team"
    t.string "category"
    t.json "tags"
    t.string "status", default: "draft"
    t.datetime "published_at"
    t.integer "view_count", default: 0
    t.string "meta_title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "brands", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "logo"
    t.text "description"
    t.integer "founded_year"
    t.string "field"
    t.text "story"
    t.string "website"
    t.boolean "is_active", default: true
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_url"
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "image"
    t.bigint "parent_id"
    t.integer "sort_order", default: 0
    t.boolean "is_active", default: true
    t.string "meta_title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "ckeditor_assets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "client_notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.bigint "order_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.string "notification_type", default: "new_order"
    t.boolean "is_read", default: false
    t.datetime "read_at"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "idx_client_notifications_on_admin_user_id"
    t.index ["admin_user_id"], name: "index_client_notifications_on_admin_user_id"
    t.index ["is_read"], name: "idx_client_notifications_on_is_read"
    t.index ["notification_type"], name: "idx_client_notifications_on_notification_type"
    t.index ["order_id"], name: "index_client_notifications_on_order_id"
  end

  create_table "coupon_usage", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "coupon_id", null: false
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.decimal "discount_amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_coupon_usage_on_coupon_id"
    t.index ["order_id"], name: "index_coupon_usage_on_order_id"
    t.index ["user_id"], name: "index_coupon_usage_on_user_id"
  end

  create_table "coupons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.text "description"
    t.string "discount_type", null: false
    t.decimal "discount_value", precision: 10, scale: 2, null: false
    t.decimal "min_order_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "max_discount_amount", precision: 10, scale: 2
    t.integer "usage_limit"
    t.integer "used_count", default: 0
    t.integer "user_limit", default: 1
    t.datetime "valid_from", null: false
    t.datetime "valid_until", null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.string "type", null: false
    t.boolean "is_read", default: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.string "product_name", null: false
    t.string "product_sku"
    t.string "product_image"
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.json "variant_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "order_number", null: false
    t.bigint "user_id"
    t.string "guest_email"
    t.string "guest_phone"
    t.string "guest_name"
    t.string "status", default: "pending"
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "shipping_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "payment_method", null: false
    t.string "payment_status", default: "pending"
    t.string "delivery_type", default: "home"
    t.text "delivery_address"
    t.string "store_location"
    t.text "notes"
    t.string "coupon_code"
    t.decimal "coupon_discount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tracking_url"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.string "shipping_name"
    t.string "shipping_phone"
    t.string "shipping_city"
    t.string "shipping_district"
    t.string "shipping_ward"
    t.string "shipping_postal_code"
    t.integer "status_processed", default: 0, null: false
    t.string "tracking_number"
    t.string "shipping_provider"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["status_processed"], name: "index_orders_on_status_processed"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_descriptions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "title"
    t.text "content"
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

  create_table "product_images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "alt_text"
    t.integer "sort_order", default: 0
    t.boolean "is_primary", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "product_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.integer "rating", null: false
    t.string "title"
    t.text "comment"
    t.boolean "is_verified_purchase", default: true
    t.boolean "is_approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_product_reviews_on_order_id"
    t.index ["product_id"], name: "index_product_reviews_on_product_id"
    t.index ["user_id"], name: "index_product_reviews_on_user_id"
  end

  create_table "product_specifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "spec_name", null: false
    t.text "spec_value", null: false
    t.integer "sort_order", default: 0
    t.string "unit"
    t.string "active", default: "1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_specifications_on_product_id"
  end

  create_table "product_variants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "variant_name", null: false
    t.string "variant_value", null: false
    t.decimal "price_adjustment", precision: 10, scale: 2, default: "0.0"
    t.integer "stock_quantity", default: 0
    t.string "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "product_videos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "url", null: false
    t.string "title"
    t.text "description"
    t.integer "sort_order", default: 0
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "sort_order"], name: "index_product_videos_on_product_id_and_sort_order"
    t.index ["product_id"], name: "index_product_videos_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "sku"
    t.text "description"
    t.string "short_description"
    t.bigint "brand_id"
    t.bigint "category_id"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "original_price", precision: 10, scale: 2
    t.decimal "discount_percent", precision: 5, scale: 2, default: "0.0"
    t.decimal "cost_price", precision: 10, scale: 2
    t.decimal "weight", precision: 8, scale: 2
    t.string "dimensions"
    t.integer "stock_quantity", default: 0
    t.integer "min_stock_alert", default: 10
    t.boolean "is_active", default: false
    t.boolean "is_essential_accessories", default: false
    t.boolean "is_new", default: false
    t.boolean "is_hot", default: false
    t.boolean "is_preorder", default: false
    t.integer "preorder_quantity", default: 0
    t.date "preorder_end_date"
    t.integer "warranty_period"
    t.string "meta_title"
    t.text "meta_description"
    t.integer "view_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_trending", default: false
    t.boolean "is_ending_soon", default: false
    t.boolean "is_arriving_soon", default: false
    t.bigint "client_id"
    t.boolean "is_best_seller", default: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["client_id"], name: "index_products_on_client_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "setting_key", null: false
    t.text "setting_value"
    t.string "setting_type", default: "string"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_key"], name: "index_settings_on_setting_key", unique: true
  end

  create_table "shipping_zones", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.json "cities", null: false
    t.decimal "shipping_fee", precision: 10, scale: 2, null: false
    t.decimal "free_shipping_threshold", precision: 10, scale: 2
    t.string "estimated_days"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "address", null: false
    t.string "phone"
    t.string "email"
    t.string "city", null: false
    t.boolean "is_active", default: true
    t.json "opening_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "full_name", null: false
    t.string "phone", null: false
    t.string "address_line1", null: false
    t.string "address_line2"
    t.string "city", null: false
    t.string "state"
    t.string "postal_code"
    t.string "country", default: "Vietnam"
    t.boolean "is_default", default: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  create_table "user_order_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "buyer_name", null: false
    t.string "buyer_email", null: false
    t.string "buyer_phone", null: false
    t.text "buyer_address", null: false
    t.string "buyer_city"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_email"], name: "idx_user_order_infos_on_buyer_email"
    t.index ["order_id"], name: "idx_user_order_infos_on_order_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "phone"
    t.string "avatar"
    t.date "date_of_birth"
    t.string "gender"
    t.boolean "is_active", default: true
    t.boolean "is_verified", default: false
    t.datetime "email_verified_at"
    t.datetime "phone_verified_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.text "address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_digest"], name: "index_users_on_password_digest"
  end

  create_table "wishlists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_wishlists_on_product_id"
    t.index ["user_id", "product_id"], name: "index_wishlists_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "article_images", "articles"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "client_notifications", "admin_users"
  add_foreign_key "client_notifications", "orders"
  add_foreign_key "coupon_usage", "coupons"
  add_foreign_key "coupon_usage", "orders"
  add_foreign_key "coupon_usage", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "product_descriptions", "products"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_reviews", "orders"
  add_foreign_key "product_reviews", "products"
  add_foreign_key "product_reviews", "users"
  add_foreign_key "product_specifications", "products"
  add_foreign_key "product_variants", "products"
  add_foreign_key "product_videos", "products"
  add_foreign_key "products", "admin_users", column: "client_id"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "user_addresses", "users"
  add_foreign_key "user_order_infos", "orders"
  add_foreign_key "wishlists", "products"
  add_foreign_key "wishlists", "users"
end
