class AddAddressDatabaseFieldsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipping_province_code, :string
    add_column :orders, :shipping_ward_code, :string
    add_column :orders, :full_address, :text
    add_column :orders, :administrative_unit_id, :integer
    add_column :orders, :administrative_unit_name, :string
    add_column :orders, :province_type, :string
    add_column :orders, :is_municipality, :boolean
  end
end
