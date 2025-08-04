class UserAddress < ApplicationRecord
  belongs_to :user

  validates :full_name, presence: true
  validates :phone, presence: true
  validates :address_line1, presence: true
  validates :city, presence: true
end 