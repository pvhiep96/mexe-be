class CreateProductVariants < ActiveRecord::Migration[7.2]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :variant_name, null: false
      t.string :variant_value, null: false
      t.decimal :price_adjustment, precision: 10, scale: 2, default: 0
      t.integer :stock_quantity, default: 0
      t.string :sku

      t.timestamps
    end
  end
end 