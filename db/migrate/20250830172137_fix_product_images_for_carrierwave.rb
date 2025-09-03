class FixProductImagesForCarrierwave < ActiveRecord::Migration[7.2]
  def change
    # Copy data from image_url to image if image_url exists
    if column_exists?(:product_images, :image_url)
      execute "UPDATE product_images SET image = image_url WHERE image_url IS NOT NULL AND image IS NULL"
      
      # Remove old image_url column
      remove_column :product_images, :image_url
    end
  end
end
