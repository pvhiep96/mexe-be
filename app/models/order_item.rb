class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_product_details, on: :create

  private

  def set_product_details
    self.product_name = product.name
    self.product_sku = product.sku
    self.unit_price = product.price
    self.total_price = 0
    # self.total_price = unit_price * quantity
  end
end
