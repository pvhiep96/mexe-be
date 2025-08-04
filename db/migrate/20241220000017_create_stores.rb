class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.text :address, null: false
      t.string :phone
      t.string :email
      t.string :city, null: false
      t.boolean :is_active, default: true
      t.json :opening_hours

      t.timestamps
    end
  end
end 