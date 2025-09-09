class RemoveLocationFieldsFromUserOrderInfos < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_order_infos, :buyer_district, :string
    remove_column :user_order_infos, :buyer_ward, :string
    remove_column :user_order_infos, :buyer_postal_code, :string
  end
end
