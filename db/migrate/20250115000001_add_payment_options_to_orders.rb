class AddPaymentOptionsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :full_payment_transfer, :boolean, default: false
    add_column :orders, :full_payment_discount_percentage, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :orders, :partial_advance_payment, :boolean, default: false
    add_column :orders, :advance_payment_percentage, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :orders, :advance_payment_discount_percentage, :decimal, precision: 5, scale: 2, default: 0.0
    
    # Add indexes for better query performance
    add_index :orders, :full_payment_transfer
    add_index :orders, :partial_advance_payment
  end
end
