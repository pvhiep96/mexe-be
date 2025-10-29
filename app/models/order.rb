class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_one :user_order_info, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :product_reviews, dependent: :destroy
  # has_many :coupon_usages, dependent: :destroy

  # Quan hệ với địa chỉ chuẩn - temporarily disabled until migration runs
  # belongs_to :shipping_province, foreign_key: 'shipping_province_code', primary_key: 'code', class_name: 'Province', optional: true
  # belongs_to :shipping_ward, foreign_key: 'shipping_ward_code', primary_key: 'code', class_name: 'Ward', optional: true

  validates :order_number, presence: true, uniqueness: true
  # validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_method, presence: true

  before_validation :calculate_totals
  after_create :notify_clients_about_new_order
  before_validation :full_tracking_url

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

  scope :processing_not_processed, -> { where(status_processed: :not_processed) }

  SHIPPING_PROVIDERS = [
    ['Giao Hàng Nhanh', 'ghn'],
    ['Giao Hàng Tiết Kiệm', 'ghtk'],
    ['Viettel Post', 'viettel_post'],
    ['Tự nhập thủ công', 'manual']
  ].freeze

  def self.ransackable_attributes(auth_object = nil)
    %w[id order_number subtotal total_amount status payment_status payment_method delivery_type status_processed shipping_provider tracking_number shipping_name shipping_phone shipping_city shipping_district shipping_ward shipping_postal_code delivery_address guest_name guest_email guest_phone full_payment_transfer full_payment_discount_percentage partial_advance_payment advance_payment_percentage advance_payment_discount_percentage created_at updated_at]
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
    # return tracking_url if tracking_url.present?
    return nil unless tracking_number.present?

    self.tracking_url = case shipping_provider
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
    # Calculate subtotal from order_items (including unsaved ones)
    if order_items.any?
      if persisted?
        # For saved orders, use database sum
        self.subtotal = order_items.sum('quantity * unit_price')
      else
        # For new orders, calculate from memory
        self.subtotal = order_items.sum { |item| (item.quantity || 0) * (item.unit_price || 0) }
      end
    else
      self.subtotal = 0.0
    end

    self.payment_method = :cod if payment_method.blank?
    self.discount_amount ||= 0.0
    self.shipping_fee ||= 0.0
    self.tax_amount ||= 0.0
    self.total_amount = subtotal - discount_amount + shipping_fee + tax_amount
  end

  # Payment calculation methods
  def full_payment_amount
    return total_amount unless full_payment_transfer?
    discount = total_amount * (full_payment_discount_percentage / 100.0)
    total_amount - discount
  end

  def advance_payment_amount
    return 0 unless partial_advance_payment?
    total_amount * (advance_payment_percentage / 100.0)
  end

  def advance_payment_with_discount
    return advance_payment_amount unless partial_advance_payment?
    discount = advance_payment_amount * (advance_payment_discount_percentage / 100.0)
    advance_payment_amount - discount
  end

  def remaining_payment_amount
    return 0 if full_payment_transfer?
    return total_amount - advance_payment_with_discount if partial_advance_payment?
    total_amount
  end

  def payment_summary
    {
      total_amount: total_amount,
      full_payment_transfer: full_payment_transfer?,
      full_payment_amount: full_payment_amount,
      full_payment_discount: full_payment_transfer? ? total_amount - full_payment_amount : 0,
      partial_advance_payment: partial_advance_payment?,
      advance_payment_amount: advance_payment_amount,
      advance_payment_with_discount: advance_payment_with_discount,
      advance_payment_discount: partial_advance_payment? ? advance_payment_amount - advance_payment_with_discount : 0,
      remaining_amount: remaining_payment_amount
    }
  end

  # Helper methods cho địa chỉ
  def shipping_province_name
    shipping_province&.name || shipping_city
  end

  def shipping_ward_name
    shipping_ward&.name || shipping_ward
  end

  def formatted_shipping_address
    address_parts = []
    address_parts << delivery_address if delivery_address.present?
    address_parts << shipping_ward_name if shipping_ward_name.present?

    if shipping_district.present?
      address_parts << shipping_district
    end

    address_parts << shipping_province_name if shipping_province_name.present?
    address_parts.compact.reject(&:blank?).join(', ')
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

    # Get order items with their products for this client
    client_order_items = order_items.joins(:product).where(products: { client_id: client.id })

    title = "Đơn hàng mới ##{order_number}"
    message = "Bạn có đơn hàng mới từ #{buyer_name}. "

    # Build product list with variant info
    product_details = client_order_items.map do |item|
      detail = item.product_name
      if item.variant_info.present?
        variant_info = item.variant_info.is_a?(Hash) ? item.variant_info : (JSON.parse(item.variant_info) rescue nil)
        if variant_info
          detail += " (#{variant_info['variant_name']}: #{variant_info['variant_value']})"
        end
      end
      detail += " x#{item.quantity}"
      detail
    end

    message += "Đơn hàng bao gồm: #{product_details.join(', ')}. "

    # Calculate total amount for client's products only (using unit_price which includes variant price)
    client_total = client_order_items.sum('order_items.quantity * order_items.unit_price')

    message += "Tổng giá trị sản phẩm của bạn: #{client_total.to_i}₫"

    # Create notification record with detailed product info
    ClientNotification.create!(
      admin_user: client,
      order: self,
      title: title,
      message: message,
      notification_type: 'new_order',
      data: {
        order_number: order_number,
        buyer_name: buyer_name,
        client_products: client_order_items.map { |item|
          {
            name: item.product_name,
            quantity: item.quantity,
            unit_price: item.unit_price,
            total_price: item.total_price,
            variant_info: item.variant_info
          }
        },
        client_total: client_total
      }
    )

    # You can also send email notification here if needed
    # ClientOrderNotificationMailer.new_order(client, self).deliver_later
  rescue StandardError => e
    # Silent fail for notification creation
  end
end
