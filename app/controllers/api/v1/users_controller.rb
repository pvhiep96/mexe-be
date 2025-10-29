module Api
  module V1
    class UsersController < Api::ApplicationController
      before_action :authenticate_user!
      before_action :ensure_json_request

      def show
        render json: UserSerializer.new(current_user).serializable_hash[:data]
      end

      def orders
        orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
        render json: orders.map { |order| OrderSerializer.new(order, include: [:order_items]).as_json }
      end

      def favorites
        wishlist_items = current_user.wishlists.includes(:product).order(created_at: :desc)
        render json: wishlist_items.map do |item|
          {
            id: item.id,
            product_id: item.product.id,
            product_name: item.product.name,
            product_image: item.product.product_images.first&.image_url,
            product_price: item.product.price,
            added_at: item.created_at
          }
        end
      end

      def addresses
        user_addresses = current_user.user_addresses.order(is_default: :desc, created_at: :desc)
        render json: user_addresses.map { |address| UserAddressSerializer.new(address).serializable_hash[:data] }
      end

      private

      def ensure_json_request
        request.format = :json
      end
    end
  end
end
