class AddMainImageToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :main_image, :string
  end
end
