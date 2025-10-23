module Api
  module V1
    class TestOrdersController < ::Api::ApplicationController
      # Test endpoint for order creation with shipping info
      def create_test_order
        # Create test order with shipping info
        test_order_params = {
          orders: {
            order_number: "TEST-#{Time.now.strftime('%Y%m%d%H%M%S')}",
            payment_method: 'cod',
            delivery_type: 'home',
            guest_name: 'Nguyen Test User',
            guest_email: 'test@example.com',
            guest_phone: '0901234567',
            notes: 'Giao hàng buổi chiều',
            shipping_info: {
              shipping_name: 'Nguyen Van A',
              shipping_phone: '0987654321',
              shipping_city: 'Ho Chi Minh City',
              shipping_district: 'District 1',
              shipping_ward: 'Ben Nghe Ward',
              shipping_postal_code: '700000',
              delivery_address: '123 Le Loi Street'
            },
            order_items: [
              {
                product_id: Product.first&.id,
                quantity: 2
              }
            ]
          }
        }

        # Call the create action with test params
        params.merge!(test_order_params)
        create
      rescue StandardError => e
        render json: {
          error: "Test order creation failed: #{e.message}",
          debug_info: {
            products_count: Product.count,
            first_product: Product.first&.attributes&.slice('id', 'name', 'price')
          }
        }, status: :unprocessable_entity
      end

      private

    end
  end
end
