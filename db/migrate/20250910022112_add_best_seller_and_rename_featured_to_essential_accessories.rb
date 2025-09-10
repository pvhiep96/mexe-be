class AddBestSellerAndRenameFeaturedToEssentialAccessories < ActiveRecord::Migration[7.2]
  def change
    # Add new is_best_seller column
    add_column :products, :is_best_seller, :boolean, default: false

    # Rename is_featured to is_essential_accessories
    rename_column :products, :is_featured, :is_essential_accessories
  end
end
