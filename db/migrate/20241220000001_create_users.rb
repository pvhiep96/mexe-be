class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_hash, null: false
      t.string :full_name, null: false
      t.string :phone
      t.string :avatar
      t.date :date_of_birth
      t.string :gender
      t.boolean :is_active, default: true
      t.boolean :is_verified, default: false
      t.datetime :email_verified_at
      t.datetime :phone_verified_at
      t.datetime :last_login_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end 