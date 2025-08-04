class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_reviews, dependent: :destroy
  has_many :coupon_usages, dependent: :destroy

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, presence: true

  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled',
    refunded: 'refunded'
  }

  enum payment_status: {
    pending: 'pending',
    paid: 'paid',
    failed: 'failed',
    refunded: 'refunded'
  }

  enum payment_method: {
    cod: 'cod',
    card: 'card',
    bank_transfer: 'bank_transfer'
  }

  enum delivery_type: {
    home: 'home',
    store: 'store'
  }
end 