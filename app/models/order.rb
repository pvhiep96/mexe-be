class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_one :user_order_info, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_reviews, dependent: :destroy
  # has_many :coupon_usages, dependent: :destroy

  validates :order_number, presence: true, uniqueness: true
  # validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_method, presence: true

  before_validation :calculate_totals, on: :create
  after_create :notify_clients_about_new_order

  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled',
    refunded: 'refunded'
  }, _suffix: true

  enum payment_status: {
    pending: 'pending',
    paid: 'paid',
    failed: 'failed',
    refunded: 'refunded'
  }, _prefix: :payment

  enum payment_method: {
    cod: 'cod',
    card: 'card',
    bank_transfer: 'bank_transfer'
  }

  enum delivery_type: {
    home: 'home',
    store_pickup: 'store'
  }

  attribute :status_processed, :integer, default: 0
  
  enum status_processed: {
    not_processed: 0,
    shipped_to_carrier: 1,
    processing_delivered: 2
  }, _prefix: :processing

  SHIPPING_PROVIDERS = [
    ['Giao Hàng Nhanh', 'ghn'],
    ['Giao Hàng Tiết Kiệm', 'ghtk'], 
    ['Viettel Post', 'viettel_post'],
    ['Tự nhập thủ công', 'manual']
  ].freeze

  def self.ransackable_attributes(auth_object = nil)
    %w[id order_number subtotal total_amount status payment_status payment_method delivery_type status_processed shipping_provider tracking_number shipping_name shipping_phone shipping_city shipping_district shipping_ward shipping_postal_code delivery_address guest_name guest_email guest_phone created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user user_order_info order_items products product_reviews coupon_usages]
  end

  # Get all clients related to this order
  def related_clients
    products.joins(:client).select('admin_users.*').distinct
  end

  # Check if order contains products from specific client
  def contains_products_from_client?(client)
    products.where(client_id: client.id).exists?
  end

  # Helper methods for status_processed with new enum names
  def processing_status_text
    case status_processed
    when 'not_processed' then 'Chưa xử lý'
    when 'shipped_to_carrier' then 'Đã giao đơn vị vận chuyển'
    when 'processing_delivered' then 'Đã giao hàng'
    end
  end

  # Get shipping provider display name
  def shipping_provider_name
    provider_hash = SHIPPING_PROVIDERS.find { |name, value| value == shipping_provider }
    provider_hash ? provider_hash[0] : shipping_provider&.humanize
  end

  # Generate tracking URL based on provider
  def full_tracking_url
    return tracking_url if tracking_url.present?
    return nil unless tracking_number.present?

    case shipping_provider
    when 'ghn'
      "https://5sao.ghn.dev/?order_code=#{tracking_number}"
    when 'ghtk'
      "https://khachhang.giaohangtietkiem.vn/khach-hang/tra-cuu-don-hang?bill_code=#{tracking_number}"
    when 'viettel_post'
      "https://viettelpost.vn/tra-cuu-hanh-trinh-don-hang?ma-don-hang=#{tracking_number}"
    else
      nil
    end
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

  private

  def notify_clients_about_new_order
    # Get all clients who have products in this order
    client_ids = products.pluck(:client_id).compact.uniq
    
    client_ids.each do |client_id|
      client = AdminUser.find_by(id: client_id)
      next unless client&.client?
      
      # Create notification for this client
      create_client_notification(client)
    end
  end

  def create_client_notification(client)
    buyer_name = user_order_info&.buyer_name || guest_name || (user&.full_name) || 'Khách hàng'
    client_products = products.where(client_id: client.id)
    
    title = "Đơn hàng mới ##{order_number}"
    message = "Bạn có đơn hàng mới từ #{buyer_name}. "
    message += "Đơn hàng bao gồm: #{client_products.pluck(:name).join(', ')}. "
    
    # Calculate total amount for client's products only
    client_total = order_items.joins(:product)
                             .where(products: { client_id: client.id })
                             .sum('order_items.quantity * order_items.unit_price')
    
    message += "Tổng giá trị sản phẩm của bạn: #{client_total.to_i}₫"
    
    # Create notification record
    ClientNotification.create!(
      admin_user: client,
      order: self,
      title: title,
      message: message,
      notification_type: 'new_order',
      data: {
        order_number: order_number,
        buyer_name: buyer_name,
        client_products: client_products.pluck(:name),
        client_total: client_total
      }
    )
    
    Rails.logger.info("Created notification for client #{client.client_name}: #{title}")
    
    # You can also send email notification here if needed
    # ClientOrderNotificationMailer.new_order(client, self).deliver_later
  rescue StandardError => e
    Rails.logger.error("Failed to create notification for client #{client&.id}: #{e.message}")
  end
end
