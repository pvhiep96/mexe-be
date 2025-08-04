class Brand < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
end 