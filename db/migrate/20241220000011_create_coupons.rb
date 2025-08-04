class CreateCoupons < ActiveRecord::Migration[7.2]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.string :discount_type, null: false
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.decimal :min_order_amount, precision: 10, scale: 2, default: 0
      t.decimal :max_discount_amount, precision: 10, scale: 2
      t.integer :usage_limit
      t.integer :used_count, default: 0
      t.integer :user_limit, default: 1
      t.datetime :valid_from, null: false
      t.datetime :valid_until, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end 