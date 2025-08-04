class Coupon < ApplicationRecord
  has_many :coupon_usages, dependent: :destroy
  has_many :users, through: :coupon_usages
  has_many :orders, through: :coupon_usages

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :discount_type, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :valid_from, presence: true
  validates :valid_until, presence: true

  enum discount_type: {
    percentage: 'percentage',
    fixed_amount: 'fixed_amount'
  }

  scope :active, -> { where(is_active: true) }
  scope :valid, -> { where('valid_from <= ? AND valid_until >= ?', Time.current, Time.current) }
end 