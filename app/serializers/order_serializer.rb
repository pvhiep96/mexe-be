# app/serializers/order_detail_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_number, :status, :subtotal, :discount_amount,
             :shipping_fee, :tax_amount, :total_amount, :payment_method,
             :payment_status, :delivery_type, :delivery_address, :store_location,
             :notes, :coupon_code, :coupon_discount, :guest_email, :guest_phone,
             :guest_name, :shipping_name, :shipping_phone, :shipping_city,
             :shipping_district, :shipping_ward, :shipping_postal_code, :created_at, :updated_at

  # Add shipping_address as an alias for delivery_address
  def shipping_address
    object.delivery_address
  end

  has_many :order_items, serializer: OrderItemSerializer
end
