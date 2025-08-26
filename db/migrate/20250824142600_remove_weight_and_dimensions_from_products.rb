class RemoveWeightAndDimensionsFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :weight, :decimal
    remove_column :products, :dimensions, :string
  end
end
