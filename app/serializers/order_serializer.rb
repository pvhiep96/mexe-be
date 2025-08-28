# app/serializers/order_detail_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_number, :status, :subtotal, :discount_amount,
             :shipping_fee, :tax_amount, :total_amount, :payment_method,
             :payment_status, :delivery_type, :delivery_address, :store_location,
             :notes, :coupon_code, :coupon_discount, :guest_email, :guest_phone,
             :guest_name, :created_at

  has_many :order_items, serializer: OrderItemSerializer
end
