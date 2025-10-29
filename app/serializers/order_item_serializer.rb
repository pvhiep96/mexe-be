class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :product_name, :product_sku, :product_image,
             :quantity, :unit_price, :total_price, :variant_info, :price, :total

  # Add price as an alias for unit_price to match frontend expectations
  def price
    object.unit_price
  end

  # Add total as an alias for total_price to match frontend expectations
  def total
    object.total_price
  end

  # Get product image from the associated product
  def product_image
    # Try to get from order_item table first (if it exists)
    return object.product_image if object.respond_to?(:product_image) && object.product_image.present?
    
    # Otherwise get from associated product
    if object.product && object.product.product_images.any?
      first_image = object.product.product_images.first
      first_image.image.url rescue nil
    else
      nil
    end
  end
end
