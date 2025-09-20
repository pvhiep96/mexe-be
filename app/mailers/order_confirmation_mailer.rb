class OrderConfirmationMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user_order_info = order.user_order_info
    @order_items = order.order_items

    # Calculate payment amounts based on product payment options
    calculate_payment_amounts

    recipient_email = @user_order_info&.buyer_email || order.guest_email
    recipient_name = @user_order_info&.buyer_name || order.guest_name

    mail(
      to: recipient_email,
      subject: "Xác nhận đơn hàng ##{@order.order_number} - Mexe Store"
    )
  end

  private

  def calculate_payment_amounts
    @original_amount = 0
    @discount_amount = 0
    @total_amount = 0

    @payment_details = []

    @order_items.each do |item|
      product = item.product
      quantity = item.quantity

      original_item_total = product.price * quantity
      @original_amount += original_item_total

      # Determine payment option for this product
      if product.full_payment_transfer?
        # Full payment with discount
        discounted_price = product.full_payment_price
        item_total = discounted_price * quantity
        item_discount = original_item_total - item_total

        @payment_details << {
          product_name: product.name,
          quantity: quantity,
          original_price: product.price,
          payment_type: :full_payment,
          discounted_price: discounted_price,
          discount_percentage: product.full_payment_discount_percentage,
          item_total: item_total,
          item_discount: item_discount
        }

      elsif product.partial_advance_payment?
        # Partial advance payment
        advance_amount = product.advance_payment_amount * quantity
        remaining_amount = product.remaining_payment_amount * quantity
        item_total = advance_amount + remaining_amount
        item_discount = original_item_total - item_total

        @payment_details << {
          product_name: product.name,
          quantity: quantity,
          original_price: product.price,
          payment_type: :partial_advance,
          advance_percentage: product.advance_payment_percentage,
          advance_amount: advance_amount,
          remaining_amount: remaining_amount,
          advance_discount_percentage: product.advance_payment_discount_percentage,
          item_total: item_total,
          item_discount: item_discount
        }

      else
        # Regular payment - no special payment options
        @payment_details << {
          product_name: product.name,
          quantity: quantity,
          original_price: product.price,
          payment_type: :regular,
          item_total: original_item_total,
          item_discount: 0
        }
      end

      @discount_amount += @payment_details.last[:item_discount]
      @total_amount += @payment_details.last[:item_total]
    end
  end
end
