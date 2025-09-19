module Api
  module V1
    class OrdersController < ::Api::ApplicationController
      before_action :authenticate_user!, only: [:index]

      def index
        # Remove binding.pry
        orders = current_user.orders
                            .includes(:order_items)
                            .where(params[:status] ? { status: params[:status] } : {})
                            .order(created_at: :desc)
                            .page(params[:page]).per(params[:per_page] || 20)

        render json: orders.map { |order| OrderSerializer.new(order).as_json }
      end

      def show
        # order = current_user.orders.find_by(id: params[:id]) || current_user.orders.find_by!(order_number: params[:id])
        order = Order.find_by(id: params[:id]) || Order.find_by(order_number: params[:id])
        render json: OrderSerializer.new(order).to_json
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def create
        # Debug logging
        Rails.logger.info "Orders params: #{params.inspect}"
        Rails.logger.info "Orders key: #{params[:orders].inspect}"

        # Check if orders params exist
        unless params[:orders]
          Rails.logger.error "Orders params missing: #{params.inspect}"
          render json: { error: 'Orders parameters are required' }, status: :bad_request
          return
        end

        order_number = params[:orders][:order_number] || generate_order_number

        order = Order.find_or_initialize_by(order_number: order_number)

        # Set user ID (use current_user if authenticated, otherwise allow guest orders)
        if current_user
          order.user_id = current_user.id
        else
          # For guest orders, save guest information
          order.guest_name = order_params[:guest_name]
          order.guest_email = order_params[:guest_email]
          order.guest_phone = order_params[:guest_phone]
        end

        # Check for existing order
        if order.persisted? && order.delivered?
          render json: { error: 'You have a recent pending order' }, status: :unprocessable_entity
          return
        end

        # Set order attributes (exclude nested parameters)
        basic_params = order_params.except(:order_items, :shipping_info, :buyer_info)
        Rails.logger.info "Order basic params: #{basic_params.inspect}"
        order.assign_attributes(basic_params)

        # Set shipping information
        Rails.logger.info "Shipping info: #{order_params[:shipping_info].inspect}"

        if order_params[:shipping_info].present?
          shipping_info = order_params[:shipping_info]
          order.shipping_name = shipping_info[:shipping_name]
          order.shipping_phone = shipping_info[:shipping_phone]
          order.shipping_city = shipping_info[:shipping_city]
          order.shipping_district = shipping_info[:shipping_district]
          order.shipping_ward = shipping_info[:shipping_ward]
          order.shipping_postal_code = shipping_info[:shipping_postal_code]
          order.delivery_address = shipping_info[:delivery_address] || build_full_address(shipping_info)
        else
          Rails.logger.warn "No shipping info found in params"
        end

        # Manually build order items
        Rails.logger.info "Order items: #{order_params[:order_items].inspect}"

        if order_params[:order_items].present?
          order_params[:order_items].each do |item_params|
            Rails.logger.info "Processing item: #{item_params.inspect}"
            product = Product.find(item_params[:product_id])
            order.order_items.build(
              product_id: product.id,
              product_name: product.name,
              product_sku: product.sku,
              quantity: item_params[:quantity],
              unit_price: product.price,
              total_price: product.price * item_params[:quantity]
              # variant_info: item_params[:variant_id] ? ProductVariant.where(product_id: product.id, variant_value: item_params[:variant_id]).as_json : nil
            )
          end
        else
          Rails.logger.warn "No order items found in params"
        end

        order.valid?
        if order.save
          order.calculate_totals
          order.save

          # Always create user_order_info record to store buyer information from shipping form
          create_user_order_info(order)

          # Send order confirmation email
          send_order_confirmation_email(order)

          render json: OrderSerializer.new(order).to_json, status: :created
        else
          Rails.logger.error("Order creation failed: #{order.errors.full_messages.join(', ')}")
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product or variant not found' }, status: :unprocessable_entity
      rescue StandardError => e
        puts e.message;
        render json: { error: "Failed to create order: #{e.message}" }, status: :unprocessable_entity
      end

#       {
#   vnp_Amount: '250000000',
#   vnp_BankCode: 'NCB',
#   vnp_BankTranNo: 'VNP15154657',
#   vnp_CardType: 'ATM',
#   vnp_OrderInfo: 'ORD-20250829-64E480A6',
#   vnp_PayDate: '20250829220319',
#   vnp_ResponseCode: '00',
#   vnp_TmnCode: '5YQD1DBZ',
#   vnp_TransactionNo: '15154657',
#   vnp_TransactionStatus: '00',
#   vnp_TxnRef: 'ORDER_1756479704666_1xe00tg4i',
#   vnp_SecureHash: 'd65c40e85507e085147e1432da8e5466a768dc51e3f7346a00abab58a10aa67435f9ab9794fa168f6641281ec7e0acbeb66e0782e8f81fb03430e16fddd1a884'
# }

      def completed
        order = Order.find_by(order_number: params[:vnp_OrderInfo])
        if(order.nil?)
          render json: { error: 'Order not found' }, status: :not_found
          return
        end

        if(order.payment_status == 'paid')
          render json: { message: 'Order already paid' }, status: :ok
          return
        end

        if(order.payment_status == 'pending')
          order.payment_status = 'paid'
          order.status = 'processing'
          if order.save
            send_order_confirmation_email(order)
            render json: { message: 'Order already paid' }, status: :ok
          else
            render json: { error: 'Failed to update order status' }, status: :unprocessable_entity
          end
        end

      end

      private

      def order_params
        params.require(:orders).permit(
          :payment_method, :delivery_type, :delivery_address, :store_location,
          :coupon_code, :guest_email, :guest_phone, :guest_name, :notes,
          shipping_info: [
            :shipping_name, :shipping_phone, :shipping_city, :shipping_district,
            :shipping_ward, :shipping_postal_code, :delivery_address
          ],
          buyer_info: [
            :buyer_name, :buyer_email, :buyer_phone, :buyer_address,
            :buyer_city, :notes
          ],
          order_items: [:product_id, :variant_id, :quantity]
        )
      end

      def generate_order_number
        "ORD-#{Time.now.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      end

      def build_full_address(shipping_info)
        address_parts = [
          shipping_info[:delivery_address],
          shipping_info[:shipping_ward],
          shipping_info[:shipping_district],
          shipping_info[:shipping_city]
        ].compact.reject(&:blank?)

        address_parts.join(', ')
      end

      def create_user_order_info(order)
        # Use shipping_info from checkout form as primary source
        shipping_info = order_params[:shipping_info]
        buyer_info = order_params[:buyer_info]

        # Determine buyer information from shipping form or user data
        if current_user
          # For logged in users, use shipping form data or fallback to user profile
          buyer_name = shipping_info&.dig(:shipping_name) || current_user.full_name
          buyer_email = current_user.email
          buyer_phone = shipping_info&.dig(:shipping_phone) || current_user.phone
        else
          # For guest users, use shipping form data or guest order data
          buyer_name = shipping_info&.dig(:shipping_name) || order.guest_name
          buyer_email = order.guest_email
          buyer_phone = shipping_info&.dig(:shipping_phone) || order.guest_phone
        end

        # Use buyer_info if provided, otherwise fall back to shipping_info/order data
        final_buyer_info = {
          buyer_name: buyer_info&.dig(:buyer_name) || buyer_name,
          buyer_email: buyer_info&.dig(:buyer_email) || buyer_email,
          buyer_phone: buyer_info&.dig(:buyer_phone) || buyer_phone,
          buyer_address: buyer_info&.dig(:buyer_address) || shipping_info&.dig(:delivery_address) || order.delivery_address,
          buyer_city: buyer_info&.dig(:buyer_city) || shipping_info&.dig(:shipping_city) || order.shipping_city,
          notes: buyer_info&.dig(:notes) || order.notes
        }

        # Only create if we have essential information
        if final_buyer_info[:buyer_name].present? && final_buyer_info[:buyer_email].present?
          Rails.logger.info("Creating UserOrderInfo with data: #{final_buyer_info.inspect}")
          order.create_user_order_info!(final_buyer_info)
        else
          Rails.logger.warn("Skipping UserOrderInfo creation - missing essential buyer information")
        end
      rescue StandardError => e
        Rails.logger.error("Failed to create user_order_info: #{e.message}")
      end

      def send_order_confirmation_email(order)
        # Reload order with associations to ensure data is fresh
        order.reload

        recipient_email = order.user_order_info&.buyer_email || order.guest_email
        if recipient_email.present?
          Rails.logger.info("Sending order confirmation email to #{recipient_email} for order #{order.order_number}")
          OrderConfirmationMailer.confirmation(order).deliver_now
        else
          Rails.logger.warn("No email address found for order #{order.order_number} - skipping email")
        end
      rescue StandardError => e
        Rails.logger.error("Failed to send order confirmation email for order #{order.order_number}: #{e.message}")
      end
    end
  end
end
