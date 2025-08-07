class User < ApplicationRecord
  has_secure_password
  
  has_many :user_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_products, through: :wishlists, source: :product
  has_many :product_reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :coupon_usages, dependent: :destroy

  enum gender: { male: 'male', female: 'female', other: 'other' }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :phone, format: { with: /\A(\+84|0)[0-9]{9,10}\z/ }, allow_blank: true
  validates :date_of_birth, presence: false
  validates :gender, inclusion: { in: genders.keys }, allow_blank: true
  validates :avatar, presence: false

  def self.ransackable_attributes(auth_object = nil)
    %w[id email full_name phone date_of_birth gender is_active is_verified email_verified_at phone_verified_at last_login_at created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user_addresses orders wishlists product_reviews notifications coupon_usages]
  end
end 