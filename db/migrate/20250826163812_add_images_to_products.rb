class AddImagesToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :images, :text
  end
end
