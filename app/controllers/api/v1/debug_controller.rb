module Api
  module V1
    class DebugController < ::Api::ApplicationController
      before_action :authenticate_user_from_token
      before_action :authenticate_user!, only: [:protected_test]

      def auth_test
        render json: { 
          message: 'Authentication working', 
          current_user: current_user ? current_user.email : 'No user',
          token_present: extract_token_from_header.present?
        }
      end

      def protected_test
        render json: { 
          message: 'Protected route working', 
          current_user: current_user.email,
          user_id: current_user.id
        }
      end

      def test_login
        render json: { 
          message: 'Test login endpoint',
          headers: request.headers.to_h.select { |k, v| k.match?(/^HTTP_/) },
          auth_header: request.headers['Authorization']
        }
      end

      private

      def extract_token_from_header
        auth_header = request.headers['Authorization']
        return nil unless auth_header
        
        # Extract token from "Bearer TOKEN" format
        auth_header.split(' ').last if auth_header.start_with?('Bearer ')
      end
    end
  end
end