class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :variant_name, presence: true
  validates :variant_value, presence: true
  validates :price_adjustment, numericality: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  # Method để tính giá cuối cùng của variant
  def price
    return 0 unless product&.price
    product.price + price_adjustment
  end

  # Method để lấy tên biến thể (alias cho variant_name)
  def name
    variant_name
  end

  # Method để kiểm tra variant có kích hoạt không
  def is_active
    stock_quantity > 0
  end

  # Method để lấy giá trị biến thể (alias cho variant_value)
  def value
    variant_value
  end

  # Method để kiểm tra variant có còn hàng không
  def in_stock?
    stock_quantity > 0
  end

  # Method để kiểm tra variant có sẵn sàng bán không
  def available?
    in_stock? && product&.is_active?
  end

  # Scope để lọc các variant có sẵn
  scope :available, -> { joins(:product).where('stock_quantity > 0').where(products: { is_active: true }) }

  # Scope để lọc theo tên biến thể
  scope :by_variant_name, ->(name) { where(variant_name: name) }

  # Scope để lọc theo giá trị biến thể
  scope :by_variant_value, ->(value) { where(variant_value: value) }

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id variant_name variant_value price_adjustment stock_quantity sku created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product]
  end
end 