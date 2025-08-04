class Store < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true

  scope :active, -> { where(is_active: true) }
end 