class Product < ApplicationRecord
  belongs_to :brand, optional: true
  belongs_to :category, optional: true
  belongs_to :client, class_name: 'AdminUser', optional: true
  has_many :product_images, dependent: :destroy
  has_many :product_descriptions, dependent: :destroy
  has_many :product_specifications, dependent: :destroy
  has_many :product_videos, dependent: :destroy
  has_many :product_variants, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_by_users, through: :wishlists, source: :user
  has_many :product_reviews, dependent: :destroy
  has_many :images, class_name: 'ProductImage'
  has_many :descriptions, class_name: 'ProductDescription'
  has_many :videos, class_name: 'ProductVideo'
  has_many :variants, class_name: 'ProductVariant'
  has_many :specifications, class_name: 'ProductSpecification'

  # Nested attributes for admin interface
  accepts_nested_attributes_for :product_images, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_descriptions, allow_destroy: true, reject_if: proc { |attr| attr['title'].blank? && attr['content'].blank? }
  accepts_nested_attributes_for :product_specifications, allow_destroy: true, reject_if: proc { |attr| attr['spec_name'].blank? && attr['spec_value'].blank? }
  accepts_nested_attributes_for :product_videos, allow_destroy: true, reject_if: proc { |attr| attr['url'].blank? && attr['title'].blank? }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  # Custom validation for is_active field
  validate :can_update_is_active?, if: :is_active_changed?

  scope :active, -> { where(is_active: true) }
  scope :essential_accessories, -> { where(is_essential_accessories: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :hot_products, -> { where(is_hot: true) }
  scope :preorder, -> { where(is_preorder: true) }
  scope :filter_by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :filter_by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name slug sku description short_description brand_id category_id price original_price discount_percent cost_price weight dimensions stock_quantity min_stock_alert is_active is_essential_accessories is_new is_hot is_preorder preorder_quantity preorder_end_date warranty_period meta_title meta_description view_count created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brand category product_images product_specifications product_videos product_variants order_items wishlists product_reviews]
  end

  # Get primary image or first image
  def primary_image
    product_images.primary.first || product_images.first
  end

  # Get primary image URL
  def primary_image_url
    return nil unless primary_image&.image_url.present?
    primary_image.image_url
  end

  private

  def can_update_is_active?
    # Get current admin user from Thread.current (set by controller)
    current_admin = Thread.current[:current_admin_user]

    if current_admin.present? && !current_admin.super_admin?
      errors.add(:is_active, "Chỉ Super Admin mới có quyền thay đổi trạng thái hiển thị sản phẩm")
    end
  end
end
