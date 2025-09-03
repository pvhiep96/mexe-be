class AddShippingInfoToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipping_name, :string
    add_column :orders, :shipping_phone, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_district, :string
    add_column :orders, :shipping_ward, :string
    add_column :orders, :shipping_postal_code, :string
  end
end
