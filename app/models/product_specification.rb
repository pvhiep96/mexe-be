class ProductSpecification < ApplicationRecord
  belongs_to :product

  validates :spec_name, presence: true
  validates :spec_value, presence: true

  scope :ordered, -> { order(sort_order: :asc) }
end 