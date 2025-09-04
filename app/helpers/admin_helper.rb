module AdminHelper
  def product_image_tag(product_image, version = :thumb, options = {})
    return content_tag(:div, "No Image", class: "no-image-placeholder") unless product_image&.image&.present?
    
    begin
      image_tag(product_image.image.url(version), options)
    rescue
      # Fallback to original image if version doesn't exist
      image_tag(product_image.image.url, options)
    end
  end

  def safe_image_tag(image_url, version = :thumb, options = {})
    begin
      image_tag(image_url.url(version), options)
    rescue
      # Fallback to original image if version doesn't exist
      image_tag(image_url.url, options)
    end
  end
end
