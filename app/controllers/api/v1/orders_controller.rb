module Api
  module V1
    class OrdersController < ::Api::ApplicationController
      before_action :authenticate_user!, only: [:index]

      def index
        # Remove binding.pry
        orders = current_user.orders
                            .includes(order_items: :product)
                            .where(params[:status] ? { status: params[:status] } : {})
                            .order(created_at: :desc)
                            .page(params[:page]).per(params[:per_page] || 20)

        render json: orders.map { |order| OrderSerializer.new(order, include: [:order_items]).as_json }
      end

      def show
        # order = current_user.orders.find_by(id: params[:id]) || current_user.orders.find_by!(order_number: params[:id])
        order = Order.includes(order_items: :product).find_by(id: params[:id]) || Order.includes(order_items: :product).find_by(order_number: params[:id])
        render json: OrderSerializer.new(order, include: [:order_items]).as_json
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def create
        # Debug: Log incoming parameters
        Rails.logger.info "Incoming order params: #{params.inspect}"
        puts "Incoming order params: #{params.inspect}"

        # Check if orders params exist
        unless params[:orders]
          render json: { error: 'Orders parameters are required' }, status: :bad_request
          return
        end

        order_number = params[:orders][:order_number] || generate_order_number
        puts "Order number: #{order_number}"

        order = Order.find_or_initialize_by(order_number: order_number)
        puts "Order found/initialized: #{order.persisted?}"

        # Set user ID (use current_user if authenticated, otherwise allow guest orders)
        if extract_token_from_header && authenticate_user_from_token && current_user
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
        order.assign_attributes(basic_params)

        # Set payment options with default values
        order.full_payment_transfer = order_params[:full_payment_transfer] || false
        order.full_payment_discount_percentage = order_params[:full_payment_discount_percentage] || 0.0
        order.partial_advance_payment = order_params[:partial_advance_payment] || false
        order.advance_payment_percentage = order_params[:advance_payment_percentage] || 0.0
        order.advance_payment_discount_percentage = order_params[:advance_payment_discount_percentage] || 0.0

        # Set shipping information
        if order_params[:shipping_info].present?
          shipping_info = order_params[:shipping_info]
          order.shipping_name = shipping_info[:shipping_name]
          order.shipping_phone = shipping_info[:shipping_phone]
          order.shipping_city = shipping_info[:shipping_city]
          order.shipping_district = shipping_info[:shipping_district]
          order.shipping_ward = shipping_info[:shipping_ward]
          order.shipping_postal_code = shipping_info[:shipping_postal_code]
          order.delivery_address = shipping_info[:delivery_address] || build_full_address(shipping_info)

          # Set new address fields from database (with error handling)
          # Store in delivery_address as fallback if new columns don't exist
          begin
            if order.respond_to?(:shipping_province_code=)
              order.shipping_province_code = shipping_info[:province_code]
              order.shipping_ward_code = shipping_info[:ward_code]
              order.full_address = shipping_info[:full_address]
              order.administrative_unit_id = shipping_info[:administrative_unit_id]
              order.administrative_unit_name = shipping_info[:administrative_unit_name]
              order.province_type = shipping_info[:province_type]
              order.is_municipality = shipping_info[:is_municipality]
              puts "✅ New address fields saved"
            else
              # Fallback: store structured address info in delivery_address
              structured_address = {
                detail: shipping_info[:delivery_address],
                ward_code: shipping_info[:ward_code],
                province_code: shipping_info[:province_code],
                full_address: shipping_info[:full_address],
                province_type: shipping_info[:province_type],
                is_municipality: shipping_info[:is_municipality]
              }
              order.delivery_address = "#{shipping_info[:delivery_address]} | #{structured_address.to_json}"
              puts "⚠️ Using fallback address storage (migration needed)"
            end
          rescue => e
            Rails.logger.warn "Address field error: #{e.message}"
            puts "Address field error: #{e.message}"
          end
        end

        # Manually build order items
        if order_params[:order_items].present?
          puts "Building order items: #{order_params[:order_items].count} items"
          order_params[:order_items].each do |item_params|
            puts "Finding product ID: #{item_params[:product_id]}"
            begin
              product = Product.find(item_params[:product_id])
              puts "Product found: #{product.name}"

              # Check if variant is specified
              variant = nil
              unit_price = product.price
              variant_info_json = nil

              if item_params[:variant_id].present?
                variant = ProductVariant.find_by(id: item_params[:variant_id], product_id: product.id)
                if variant
                  puts "Variant found: #{variant.variant_name} - #{variant.variant_value}"
                  unit_price = product.price + (variant.price_adjustment || 0)
                  variant_info_json = {
                    variant_id: variant.id,
                    variant_name: variant.variant_name,
                    variant_value: variant.variant_value,
                    variant_sku: variant.sku,
                    price_adjustment: variant.price_adjustment,
                    final_price: unit_price
                  }
                end
              end

              order.order_items.build(
                product_id: product.id,
                product_name: product.name,
                product_sku: variant ? variant.sku : product.sku,
                quantity: item_params[:quantity],
                unit_price: unit_price,
                total_price: unit_price * item_params[:quantity],
                variant_info: variant_info_json
              )
            rescue ActiveRecord::RecordNotFound => e
              puts "❌ Product not found: #{item_params[:product_id]}"
              render json: { error: "Product with ID #{item_params[:product_id]} not found" }, status: :unprocessable_entity
              return
            end
          end
        end

        order.valid?

        # Debug: Log validation errors
        if order.errors.any?
          Rails.logger.error "Order validation errors: #{order.errors.full_messages}"
          puts "Order validation errors: #{order.errors.full_messages}"
        end

        if order.save
          # Always create user_order_info record to store buyer information from shipping form
          create_user_order_info(order)

          # Send order confirmation email
          send_order_confirmation_email(order)

          render json: OrderSerializer.new(order).to_json, status: :created
        else
          Rails.logger.error "Failed to save order: #{order.errors.full_messages}"
          puts "Failed to save order: #{order.errors.full_messages}"
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        puts "❌ RecordNotFound: #{e.message}"
        Rails.logger.error "RecordNotFound: #{e.message}"
        render json: { error: 'Product or variant not found' }, status: :unprocessable_entity
      rescue StandardError => e
        puts "❌ StandardError: #{e.message}"
        puts "Backtrace: #{e.backtrace.first(5)}"
        Rails.logger.error "StandardError: #{e.message}"
        Rails.logger.error "Backtrace: #{e.backtrace.first(10)}"
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
          :order_number, :payment_method, :delivery_type, :delivery_address, :store_location,
          :coupon_code, :guest_email, :guest_phone, :guest_name, :notes,
          # Payment options
          :full_payment_transfer, :full_payment_discount_percentage,
          :partial_advance_payment, :advance_payment_percentage, :advance_payment_discount_percentage,
          shipping_info: [
            :shipping_name, :shipping_phone, :shipping_city, :shipping_district,
            :shipping_ward, :shipping_postal_code, :delivery_address,
            # New address fields from database
            :province_code, :ward_code, :full_address,
            :administrative_unit_id, :administrative_unit_name,
            :province_type, :is_municipality
          ],
          buyer_info: [
            :buyer_name, :buyer_email, :buyer_phone, :buyer_address,
            :buyer_city, :notes
          ],
          order_items: [
            :product_id, :variant_id, :quantity,
            # Payment options for items
            :full_payment_transfer, :full_payment_discount_percentage,
            :partial_advance_payment, :advance_payment_percentage, :advance_payment_discount_percentage
          ]
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
          order.create_user_order_info!(final_buyer_info)
        end
      rescue StandardError => e
        # Silent fail for user_order_info creation
      end

      def send_order_confirmation_email(order)
        # Reload order with associations to ensure data is fresh
        order.reload

        recipient_email = order.user_order_info&.buyer_email || order.guest_email
        if recipient_email.present?
          OrderConfirmationMailer.confirmation(order).deliver_now
        end
      rescue StandardError => e
        # Silent fail for email sending
      end

      def extract_token_from_header
        auth_header = request.headers['Authorization']
        return nil unless auth_header

        # Extract token from "Bearer TOKEN" format
        @token = auth_header.split(' ').last if auth_header.start_with?('Bearer ')
      end

      def authenticate_user_from_token
        return unless @token

        user_id = JwtService.extract_user_id(@token)
        Rails.logger.debug "User ID from token: #{user_id}"

        @current_user = User.find_by(id: user_id) if user_id
        Rails.logger.debug "Current user found: #{@current_user ? @current_user.email : 'None'}"
      end
    end
  end
end
