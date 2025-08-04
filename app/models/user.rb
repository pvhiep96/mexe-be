class User < ApplicationRecord
  has_many :user_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_products, through: :wishlists, source: :product
  has_many :product_reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :coupon_usages, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :password_hash, presence: true

  enum gender: { male: 'male', female: 'female', other: 'other' }
end 