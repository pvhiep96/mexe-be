class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id product_name quantity unit_price total_price created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order product]
  end
end 