class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
  scope :root_categories, -> { where(parent_id: nil) }
end 