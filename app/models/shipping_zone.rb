class ShippingZone < ApplicationRecord
  validates :name, presence: true
  validates :cities, presence: true
  validates :shipping_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
end 