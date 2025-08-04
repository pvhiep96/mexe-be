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
end 