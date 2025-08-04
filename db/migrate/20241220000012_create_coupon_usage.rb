class CreateCouponUsage < ActiveRecord::Migration[7.2]
  def change
    create_table :coupon_usage do |t|
      t.references :coupon, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.decimal :discount_amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end 