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

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id code name description discount_type discount_value min_order_amount max_usage_per_user max_total_usage valid_from valid_until is_active created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[coupon_usages users orders]
  end
end 