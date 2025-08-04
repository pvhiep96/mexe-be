class CouponUsage < ApplicationRecord
  belongs_to :coupon
  belongs_to :user
  belongs_to :order

  validates :discount_amount, presence: true, numericality: { greater_than: 0 }
end 