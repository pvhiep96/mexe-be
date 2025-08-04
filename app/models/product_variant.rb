class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :variant_name, presence: true
  validates :variant_value, presence: true
  validates :price_adjustment, numericality: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
end 