module Api
  module V1
    class OrdersController < ::Api::ApplicationController
      # before_action :authenticate_user!, only: [:index, :show]

      def index
        orders = current_user.orders
                            .where(params[:status] ? { status: params[:status] } : {})
                            .page(params[:page]).per(params[:per_page] || 20)
        render json: {
          orders: OrderSerializer.new(orders),
          meta: {
            total: orders.total_count,
            page: params[:page] || 1,
            per_page: params[:per_page] || 20
          }
        }
      end

      def show
        # order = current_user.orders.find_by(id: params[:id]) || current_user.orders.find_by!(order_number: params[:id])
        order = Order.find_by(id: params[:id]) || Order.find_by(order_number: params[:id])
        render json: OrderSerializer.new(order).to_json
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def create
        order_number = params[:orders][:order_number] || generate_order_number

        order = Order.find_or_initialize_by(order_number: order_number)
        order.user_id = User.first
        if(order.delivered?)
          render json: { error: 'You have a recent pending order' }, status: :unprocessable_entity
          return
        end
        # Manually build order items
        order_params[:order_items]&.each do |item_params|
          product = Product.find(item_params[:product_id])
          order.order_items.build(
            product_id: product.id,
            product_name: product.name,
            product_sku: product.sku,
            quantity: item_params[:quantity],
            unit_price: product.price,
            total_price: product.price * item_params[:quantity],
            variant_info: item_params[:variant_id] ? ProductVariant.find(item_params[:variant_id]).as_json : nil
          )
        end

        if order.save
          render json: OrderSerializer.new(order).to_json, status: :created
        else
          Rails.logger.info("==============#{order.errors.to_json}")
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product or variant not found' }, status: :unprocessable_entity
      rescue StandardError => e
        Rails.logger.info("============== #{e.message}")
        render json: { error: "Failed to create order: #{e.message}" }, status: :unprocessable_entity
      end

      private

      def order_params
        params.require(:orders).permit(
          :payment_method, :delivery_type, :delivery_address, :store_location,
          :coupon_code, :guest_email, :guest_phone, :guest_name,
          order_items: [:product_id, :variant_id, :quantity]
        )
      end

      def generate_order_number
        "ORD-#{Time.now.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      end
    end
  end
end
