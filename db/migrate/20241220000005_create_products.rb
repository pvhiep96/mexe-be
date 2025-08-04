class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sku
      t.text :description
      t.string :short_description
      t.references :brand, null: true, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :original_price, precision: 10, scale: 2
      t.decimal :discount_percent, precision: 5, scale: 2, default: 0
      t.decimal :cost_price, precision: 10, scale: 2
      t.decimal :weight, precision: 8, scale: 2
      t.string :dimensions
      t.integer :stock_quantity, default: 0
      t.integer :min_stock_alert, default: 10
      t.boolean :is_active, default: true
      t.boolean :is_featured, default: false
      t.boolean :is_new, default: false
      t.boolean :is_hot, default: false
      t.boolean :is_preorder, default: false
      t.integer :preorder_quantity, default: 0
      t.date :preorder_end_date
      t.integer :warranty_period
      t.string :meta_title
      t.text :meta_description
      t.integer :view_count, default: 0

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
  end
end 