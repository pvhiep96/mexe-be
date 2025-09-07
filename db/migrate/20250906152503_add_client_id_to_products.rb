class AddClientIdToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :client, null: true, foreign_key: { to_table: :admin_users }, index: true
  end
end
