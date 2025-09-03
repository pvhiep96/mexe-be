class CreateProductVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :product_videos do |t|
      t.references :product, null: false, foreign_key: true
      t.string :url, null: false
      t.string :title
      t.text :description
      t.integer :sort_order, default: 0
      t.boolean :is_active, default: true

      t.timestamps
    end
    
    add_index :product_videos, [:product_id, :sort_order]
  end
end
