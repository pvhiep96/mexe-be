class RemoveTitleFromProductImages < ActiveRecord::Migration[7.2]
  def change
    remove_column :product_images, :title, :string
  end
end
