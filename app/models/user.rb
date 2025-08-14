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

  enum gender: { male: 'male', female: 'female', other: 'other' }

  # Use Rails' built-in secure password
  has_secure_password

  def valid_password?(password)
    authenticate(password)
  end

  def name
    full_name
  end

  def name=(value)
    self.full_name = value
  end

  def phone=(value)
    self[:phone] = value
  end

  def date_of_birth=(value)
    self[:date_of_birth] = value.is_a?(String) ? Date.parse(value) : value
  end

  def address=(value)
    self[:address] = value
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email full_name phone date_of_birth gender is_active is_verified email_verified_at phone_verified_at last_login_at created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user_addresses orders wishlists product_reviews notifications coupon_usages]
  end
end 