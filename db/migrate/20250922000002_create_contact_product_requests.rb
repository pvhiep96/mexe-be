class CreateContactProductRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_product_requests do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.references :product, null: false, foreign_key: true
      t.timestamps
    end

    add_index :contact_product_requests, :email
    add_index :contact_product_requests, :created_at
  end
end
