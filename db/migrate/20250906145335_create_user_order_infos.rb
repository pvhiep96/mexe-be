class CreateUserOrderInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :user_order_infos do |t|
      t.references :order, null: false, foreign_key: true, index: false
      t.string :buyer_name, null: false
      t.string :buyer_email, null: false  
      t.string :buyer_phone, null: false
      t.text :buyer_address, null: false
      t.string :buyer_city
      t.string :buyer_district
      t.string :buyer_ward
      t.string :buyer_postal_code
      t.text :notes
      t.timestamps
    end
    
    add_index :user_order_infos, :order_id, unique: true, name: 'idx_user_order_infos_on_order_id'
    add_index :user_order_infos, :buyer_email, name: 'idx_user_order_infos_on_buyer_email'
  end
end
