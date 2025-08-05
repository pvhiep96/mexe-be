class Product < ApplicationRecord
  belongs_to :brand, optional: true
  belongs_to :category, optional: true
  has_many :product_images, dependent: :destroy
  has_many :product_specifications, dependent: :destroy
  has_many :product_variants, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_by_users, through: :wishlists, source: :user
  has_many :product_reviews, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :featured, -> { where(is_featured: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :hot_products, -> { where(is_hot: true) }
  scope :preorder, -> { where(is_preorder: true) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name slug sku description short_description brand_id category_id price original_price discount_percent cost_price weight dimensions stock_quantity min_stock_alert is_active is_featured is_new is_hot is_preorder preorder_quantity preorder_end_date warranty_period meta_title meta_description view_count created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brand category product_images product_specifications product_variants order_items wishlists product_reviews]
  end
end 