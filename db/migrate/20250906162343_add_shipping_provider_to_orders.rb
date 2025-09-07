class AddShippingProviderToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipping_provider, :string
  end
end
