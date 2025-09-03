class AddRoleToAdminUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :admin_users, :role, :integer, default: 0, null: false
    add_column :admin_users, :client_name, :string
    add_column :admin_users, :client_phone, :string
    add_column :admin_users, :client_address, :text
    add_index :admin_users, :role
  end
end
