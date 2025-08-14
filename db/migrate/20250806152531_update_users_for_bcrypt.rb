class UpdateUsersForBcrypt < ActiveRecord::Migration[7.2]
  def change
    # Xóa cột password_hash cũ
    remove_column :users, :password_hash, :string
    
    # Thêm cột password_digest cho bcrypt
    add_column :users, :password_digest, :string
    
    # Thêm index cho password_digest
    add_index :users, :password_digest
  end
end
