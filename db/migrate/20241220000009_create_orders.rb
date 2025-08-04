class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.references :user, null: true, foreign_key: true
      t.string :guest_email
      t.string :guest_phone
      t.string :guest_name
      t.string :status, default: 'pending'
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0
      t.decimal :shipping_fee, precision: 10, scale: 2, default: 0
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.string :payment_method, null: false
      t.string :payment_status, default: 'pending'
      t.string :delivery_type, default: 'home'
      t.text :delivery_address
      t.string :store_location
      t.text :notes
      t.string :coupon_code
      t.decimal :coupon_discount, precision: 10, scale: 2, default: 0

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
  end
end 