class CreateProductDescriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :product_descriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :sort_order, default: 0
      t.timestamps
    end
  end
end
