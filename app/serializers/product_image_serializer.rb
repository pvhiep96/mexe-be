class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :alt_text, :sort_order, :is_primary

  # Add image_url method for API compatibility
  def image_url
    return nil unless object.image.present?
    url = object.image.url
    url.present? ? url : nil
  end
end
