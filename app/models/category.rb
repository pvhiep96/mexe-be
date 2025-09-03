class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
  scope :root_categories, -> { where(parent_id: nil) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name slug description is_active parent_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[parent subcategories products]
  end
end 