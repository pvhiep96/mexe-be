class ProductImage < ApplicationRecord
  belongs_to :product

  validates :image_url, presence: true

  scope :primary, -> { where(is_primary: true) }
  scope :ordered, -> { order(sort_order: :asc) }
end 