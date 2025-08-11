class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id, :variant_name, :variant_value, :price_adjustment,
             :stock_quantity, :sku
end
