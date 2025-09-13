class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  # Role system
  enum :role, {
    super_admin: 0,
    client: 1
  }

  # Associations
  has_many :products, foreign_key: :client_id, dependent: :destroy
  has_many :order_items_as_client, through: :products, source: :order_items
  has_many :orders_as_client, through: :order_items_as_client, source: :order
  has_many :client_notifications, dependent: :destroy
  has_many :product_approvals, dependent: :destroy

  # Validations
  validates :client_name, presence: true, if: :client?
  validates :client_phone, presence: true, if: :client?


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

  # Check if user can manage products
  def can_manage_products?
    super_admin? || client?
  end

  # Check if user can manage orders
  def can_manage_orders?
    super_admin? || client?
  end

  # Check if user can view analytics
  def can_view_analytics?
    super_admin? || client?
  end

  # Check if user can approve products
  def can_approve_products?
    super_admin?
  end

  # Check if user can manage other admin users
  def can_manage_admin_users?
    super_admin?
  end
end
