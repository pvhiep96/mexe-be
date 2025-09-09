class ClientNotification < ApplicationRecord
  belongs_to :admin_user
  belongs_to :order

  validates :title, presence: true
  validates :message, presence: true
  validates :notification_type, presence: true

  enum notification_type: {
    new_order: 'new_order',
    order_update: 'order_update',
    product_low_stock: 'product_low_stock'
  }

  scope :unread, -> { where(is_read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update!(is_read: true, read_at: Time.current)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id admin_user_id order_id title message notification_type is_read read_at created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[admin_user order]
  end
end