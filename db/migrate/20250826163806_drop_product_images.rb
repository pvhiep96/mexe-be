class DropProductImages < ActiveRecord::Migration[7.2]
  def up
    drop_table :product_images if table_exists?(:product_images)
  end

  def down
    # Recreation of product_images table if needed to rollback
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :image
      t.integer :position, default: 1
      t.boolean :is_active, default: true
      t.timestamps
    end
    
    add_index :product_images, [:product_id, :position]
    add_index :product_images, :is_active
  end
end
