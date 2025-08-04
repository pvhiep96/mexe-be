class CreateUserAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :user_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :address_line1, null: false
      t.string :address_line2
      t.string :city, null: false
      t.string :state
      t.string :postal_code
      t.string :country, default: 'Vietnam'
      t.boolean :is_default, default: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end 