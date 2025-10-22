class AddExternalToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipped_at, :datetime
    add_column :orders, :tracking_url, :string
  end
end
