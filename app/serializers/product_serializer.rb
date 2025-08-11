class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :price, :original_price, :discount_percent,
             :is_active, :is_featured, :is_new, :is_hot, :stock_quantity
end
