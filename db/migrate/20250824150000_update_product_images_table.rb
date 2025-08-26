class UpdateProductImagesTable < ActiveRecord::Migration[7.2]
  def change
    # Remove old columns
    remove_column :product_images, :image_url, :string
    remove_column :product_images, :is_primary, :boolean
    remove_column :product_images, :sort_order, :integer
    
    # Add new columns
    add_column :product_images, :title, :string, null: false
    add_column :product_images, :position, :integer, null: false
    add_column :product_images, :is_active, :boolean, default: true
    
    # Add indexes
    add_index :product_images, :position
    add_index :product_images, :is_active
  end
end
