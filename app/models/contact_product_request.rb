class ContactProductRequest < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email phone product_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product]
  end
end
