class AddPaymentOptionsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :full_payment_transfer, :boolean, default: false
    add_column :products, :partial_advance_payment, :boolean, default: false
    add_column :products, :advance_payment_percentage, :decimal, precision: 5, scale: 2
    add_column :products, :full_payment_discount_percentage, :decimal, precision: 5, scale: 2
    add_column :products, :advance_payment_discount_percentage, :decimal, precision: 5, scale: 2
  end
end
