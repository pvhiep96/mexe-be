class ChangeIsActiveDefaultToFalseInProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_default :products, :is_active, false
  end
end
