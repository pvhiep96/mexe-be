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

      # Use item's unit_price (which includes variant price if applicable)
      unit_price = item.unit_price
      original_item_total = unit_price * quantity
      @original_amount += original_item_total

      # Get variant information if available
      variant_info = item.variant_info.is_a?(Hash) ? item.variant_info : (JSON.parse(item.variant_info) rescue nil)
      variant_display = nil
      if variant_info
        variant_display = "#{variant_info['variant_name']}: #{variant_info['variant_value']}"
        variant_display += " (#{variant_info['variant_sku']})" if variant_info['variant_sku']
      end

      # Determine payment option for this product
      if @order.full_payment_transfer?
        # Full payment with discount - apply discount to unit_price (includes variant price)
        discount_percentage = @order.full_payment_discount_percentage.to_f
        discounted_price = unit_price * (1 - discount_percentage / 100)
        item_total = discount_percentage > 0 ? discounted_price * quantity : original_item_total
        item_discount = original_item_total - item_total

        @payment_details << {
          product_name: product.name,
          variant_display: variant_display,
          quantity: quantity,
          original_price: unit_price,
          payment_type: :full_payment,
          discounted_price: discounted_price,
          discount_percentage: discount_percentage,
          item_total: item_total,
          item_discount: item_discount
        }

      elsif @order.partial_advance_payment?
        # Partial advance payment - calculate based on unit_price (includes variant price)
        advance_percentage = @order.advance_payment_percentage.to_f
        advance_discount_percentage = @order.advance_payment_discount_percentage.to_f

        advance_amount = (original_item_total * advance_percentage / 100)
        remaining_amount = original_item_total - advance_amount

        # Apply discount to advance payment
        advance_discount = advance_discount_percentage > 0 ? (advance_amount * advance_discount_percentage / 100) : 0
        item_total = original_item_total - advance_discount
        item_discount = advance_discount

        @payment_details << {
          product_name: product.name,
          variant_display: variant_display,
          quantity: quantity,
          original_price: unit_price,
          payment_type: :partial_advance,
          advance_percentage: advance_percentage,
          advance_amount: advance_amount,
          remaining_amount: remaining_amount,
          advance_discount_percentage: advance_discount_percentage,
          item_total: item_total,
          item_discount: item_discount
        }

      else
        # Regular payment - no special payment options
        @payment_details << {
          product_name: product.name,
          variant_display: variant_display,
          quantity: quantity,
          original_price: unit_price,
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
