class UpdateProductSpecificationsAddMissingFields < ActiveRecord::Migration[7.2]
  def change
    # Add missing fields
    add_column :product_specifications, :unit, :string
    add_column :product_specifications, :is_active, :boolean, default: true
    
    # Rename sort_order to position for consistency
    rename_column :product_specifications, :sort_order, :position
    
    # Add index for better performance
    add_index :product_specifications, :position
    add_index :product_specifications, :is_active
  end
end
