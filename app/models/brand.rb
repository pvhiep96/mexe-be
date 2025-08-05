class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name slug logo description founded_year field story website is_active sort_order created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end
end 