class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :product_name, :product_sku, :product_image,
             :quantity, :unit_price, :total_price, :variant_info
end
