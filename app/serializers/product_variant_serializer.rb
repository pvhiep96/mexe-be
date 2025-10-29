class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id, :variant_name, :variant_value, :price_adjustment,
             :stock_quantity, :sku, :final_price, :is_available

  def final_price
    base_price = object.product.price || 0
    adjustment = object.price_adjustment || 0
    base_price + adjustment
  end

  def is_available
    (object.stock_quantity || 0) > 0
  end
end
