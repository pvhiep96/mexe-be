class CreateProductSpecifications < ActiveRecord::Migration[7.2]
  def change
    create_table :product_specifications do |t|
      t.references :product, null: false, foreign_key: true
      t.string :spec_name, null: false
      t.text :spec_value, null: false
      t.integer :sort_order, default: 0

      t.timestamps
    end
  end
end 