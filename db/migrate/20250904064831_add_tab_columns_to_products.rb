class AddTabColumnsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :is_trending, :boolean, default: false
    add_column :products, :is_ending_soon, :boolean, default: false
    add_column :products, :is_arriving_soon, :boolean, default: false
  end
end
