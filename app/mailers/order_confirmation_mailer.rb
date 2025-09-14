class OrderConfirmationMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user_order_info = order.user_order_info
    @order_items = order.order_items

    recipient_email = @user_order_info&.buyer_email || order.guest_email
    recipient_name = @user_order_info&.buyer_name || order.guest_name

    mail(
      to: recipient_email,
      subject: "Xác nhận đơn hàng ##{@order.order_number} - Mexe Store"
    )
  end
end
