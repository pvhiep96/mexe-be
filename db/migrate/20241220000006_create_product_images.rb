class CreateProductImages < ActiveRecord::Migration[7.2]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :image_url, null: false
      t.string :alt_text
      t.integer :sort_order, default: 0
      t.boolean :is_primary, default: false

      t.timestamps
    end
  end
end 