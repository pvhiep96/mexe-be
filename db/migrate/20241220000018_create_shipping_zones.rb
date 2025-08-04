class CreateShippingZones < ActiveRecord::Migration[7.2]
  def change
    create_table :shipping_zones do |t|
      t.string :name, null: false
      t.json :cities, null: false
      t.decimal :shipping_fee, precision: 10, scale: 2, null: false
      t.decimal :free_shipping_threshold, precision: 10, scale: 2
      t.string :estimated_days
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end 