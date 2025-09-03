class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :product_name, :product_sku, :product_image,
             :quantity, :unit_price, :total_price, :variant_info

  # Add price as an alias for unit_price to match frontend expectations
  def price
    object.unit_price
  end

  # Add total as an alias for total_price to match frontend expectations
  def total
    object.total_price
  end
end
