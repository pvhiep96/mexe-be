# app/serializers/order_detail_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_number, :status, :subtotal, :discount_amount,
             :shipping_fee, :tax_amount, :total_amount, :payment_method,
             :payment_status, :delivery_type, :delivery_address, :store_location,
             :notes, :coupon_code, :coupon_discount, :guest_email, :guest_phone,
             :guest_name, :shipping_name, :shipping_phone, :shipping_city,
             :shipping_district, :shipping_ward, :shipping_postal_code, :created_at, :updated_at,
             :buyer_info, :payment_summary,
             # Payment options
             :full_payment_transfer, :full_payment_discount_percentage,
             :partial_advance_payment, :advance_payment_percentage, :advance_payment_discount_percentage

  # Add shipping_address as an alias for delivery_address
  def shipping_address
    object.delivery_address
  end

  # Include buyer information from user_order_info
  def buyer_info
    if object.user_order_info
      {
        buyer_name: object.user_order_info.buyer_name,
        buyer_email: object.user_order_info.buyer_email,
        buyer_phone: object.user_order_info.buyer_phone,
        buyer_address: object.user_order_info.buyer_address,
        buyer_city: object.user_order_info.buyer_city,
        notes: object.user_order_info.notes
      }
    else
      nil
    end
  end

  has_many :order_items, serializer: OrderItemSerializer
end
