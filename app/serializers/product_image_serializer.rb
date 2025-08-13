class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :alt_text, :sort_order, :is_primary
end
