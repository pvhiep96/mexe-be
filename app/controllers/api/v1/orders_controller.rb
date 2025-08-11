module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user!, only: [:index, :show]

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
        order = current_user.orders.find_by(id: params[:id]) || current_user.orders.find_by!(order_number: params[:id])
        render json: OrderDetailSerializer.new(order)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      def create
        order = Order.new(order_params)
        order.user = current_user if user_signed_in?
        order.order_number = generate_order_number

        if order.save
          render json: OrderSerializer.new(order), status: :created
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def order_params
        params.require(:order).permit(
          :payment_method, :delivery_type, :delivery_address, :store_location,
          :coupon_code, :guest_email, :guest_phone, :guest_name,
          items: [:product_id, :variant_id, :quantity]
        )
      end

      def generate_order_number
        "ORD-#{Time.now.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      end
    end
  end
end
