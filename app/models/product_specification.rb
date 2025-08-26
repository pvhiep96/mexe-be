class ProductSpecification < ApplicationRecord
  belongs_to :product

  validates :spec_name, presence: true
  validates :spec_value, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :is_active, inclusion: { in: [true, false] }

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(position: :asc) }

  # Callback để tự động set position nếu không có
  before_validation :set_default_position, on: :create

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id spec_name spec_value unit position is_active created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product]
  end

  private

  def set_default_position
    if position.blank?
      max_position = product.product_specifications.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end 