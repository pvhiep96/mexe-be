class Product < ApplicationRecord
  belongs_to :brand, optional: true
  belongs_to :category, optional: true
  has_many :product_specifications, dependent: :destroy
  has_many :product_variants, dependent: :destroy
  has_many :product_descriptions, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_by_users, through: :wishlists, source: :user
  has_many :product_reviews, dependent: :destroy
  has_many :variants, class_name: 'ProductVariant'

  # Active Storage for main image
  has_one_attached :main_image
  
  # Active Storage for multiple images (if needed)
  has_many_attached :images

  # Nested attributes
  accepts_nested_attributes_for :product_specifications, 
                                allow_destroy: true, 
                                reject_if: :all_blank
  accepts_nested_attributes_for :product_descriptions, 
                                allow_destroy: true, 
                                reject_if: :all_blank
  accepts_nested_attributes_for :product_images, 
                                allow_destroy: true, 
                                reject_if: :all_blank

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :featured, -> { where(is_featured: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :hot_products, -> { where(is_hot: true) }
  scope :preorder, -> { where(is_preorder: true) }
  scope :filter_by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :filter_by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }

  # Method để kiểm tra sản phẩm có kích hoạt không
  def is_active
    self[:is_active] || false
  end

  # Method để kiểm tra có ảnh không
  def has_images?
    main_image.attached? || product_images.active.any?
  end

  # Method để lấy tất cả ảnh
  def all_images
    images = []
    images << main_image if main_image.attached?
    images += product_images.active.ordered.map(&:image)
    images
  end

  # Method để lấy mô tả chính (đầu tiên theo position)
  def main_description
    product_descriptions.active.ordered.first
  end

  # Method để lấy tất cả mô tả
  def all_descriptions
    product_descriptions.active.ordered
  end

  # Method để lấy thông số chính (đầu tiên theo position)
  def main_specification
    product_specifications.active.ordered.first
  end

  # Method để lấy tất cả thông số
  def all_specifications
    product_specifications.active.ordered
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name slug sku short_description brand_id category_id price original_price discount_percent cost_price stock_quantity min_stock_alert is_active is_featured is_new is_hot is_preorder preorder_quantity preorder_end_date warranty_period view_count created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brand category product_specifications product_variants product_descriptions product_images order_items wishlists product_reviews]
  end
end
