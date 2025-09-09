class UserOrderInfo < ApplicationRecord
  belongs_to :order

  validates :buyer_name, presence: true
  validates :buyer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :buyer_phone, presence: true
  validates :buyer_address, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id order_id buyer_name buyer_email buyer_phone buyer_address buyer_city notes created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order]
  end
end