module Api
  module V1
    class OrdersController < ::Api::ApplicationController
      before_action :authenticate_user!, only: [:index, :show]

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
        
        # Set order attributes
        Rails.logger.info "Order params (except items): #{order_params.except(:order_items).inspect}"
        order.assign_attributes(order_params.except(:order_items))
        
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

      private

      def order_params
        params.require(:orders).permit(
          :payment_method, :delivery_type, :delivery_address, :store_location,
          :coupon_code, :guest_email, :guest_phone, :guest_name, :notes,
          shipping_info: [
            :shipping_name, :shipping_phone, :shipping_city, :shipping_district,
            :shipping_ward, :shipping_postal_code, :delivery_address
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
    end
  end
end
