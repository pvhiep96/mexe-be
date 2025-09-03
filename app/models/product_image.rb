class ProductImage < ApplicationRecord
  belongs_to :product

  # Use CarrierWave for image uploads
  mount_uploader :image, ImageUploader

  # validates :image, presence: { message: "Please select an image file" }

  scope :primary, -> { where(is_primary: true) }
  scope :ordered, -> { order(sort_order: :asc) }

  # Add image_url method for API compatibility
  def image_url
    image.url if image.present?
  end
end 