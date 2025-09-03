class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  # Role system
  enum role: {
    super_admin: 0,
    client: 1
  }

  # Associations
  has_many :products, foreign_key: :client_id, dependent: :destroy
  has_many :orders_as_client, through: :products, source: :orders

  # Validations
  validates :client_name, presence: true, if: :client?
  validates :client_phone, presence: true, if: :client?

  def self.ransackable_attributes(auth_object = nil)
    %w[id email role client_name client_phone created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end

  def display_name
    case role
    when 'super_admin'
      "Super Admin - #{email}"
    when 'client'
      client_name.present? ? "#{client_name} (#{email})" : email
    else
      email
    end
  end
end
