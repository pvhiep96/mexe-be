class ProductDescription < ApplicationRecord
  belongs_to :product

  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 65000 }
  validates :sort_order, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:sort_order) }
end