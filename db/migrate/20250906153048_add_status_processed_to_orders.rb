class AddStatusProcessedToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :status_processed, :integer, default: 0, null: false
    add_index :orders, :status_processed
  end
end
