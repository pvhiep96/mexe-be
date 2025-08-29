class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_reviews, dependent: :destroy
  # has_many :coupon_usages, dependent: :destroy

  validates :order_number, presence: true, uniqueness: true
  # validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_method, presence: true

  before_validation :calculate_totals, on: :create

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
    payment_pending: 'pending',
    paid: 'paid',
    failed: 'failed',
    payment_refunded: 'refunded'
  }

  enum payment_method: {
    cod: 'cod',
    card: 'card',
    bank_transfer: 'bank_transfer'
  }

  enum delivery_type: {
    home: 'home',
    store_pickup: 'store'
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[id order_number subtotal total_amount status payment_status payment_method delivery_type created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user order_items products product_reviews coupon_usages]
  end

  def calculate_totals
    self.subtotal = order_items.sum('quantity * unit_price')
    self.payment_method = :cod
    self.discount_amount ||= 0.0
    self.shipping_fee ||= 0.0
    self.tax_amount ||= 0.0
    self.total_amount = 0
    self.total_amount = subtotal - discount_amount + shipping_fee + tax_amount
    # save
  end
end
