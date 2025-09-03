class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :alt_text, :sort_order, :is_primary

  # Add image_url method for API compatibility
  def image_url
    object.image.url if object.image.present?
  end
end
