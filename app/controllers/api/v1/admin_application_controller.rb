module Api
  module V1
    class AdminApplicationController < Api::ApplicationController
      before_action :authenticate_admin_user!

      private

      def authenticate_admin_user!
        token = extract_token_from_header
        Rails.logger.debug "Admin Auth Header Token: #{token ? 'Present' : 'Missing'}"
        
        unless token
          render json: { 
            error: 'Unauthorized',
            message: 'Token không được cung cấp'
          }, status: :unauthorized
          return
        end

        # Verify token and get admin user
        admin_user_id = JwtService.extract_admin_user_id(token)
        Rails.logger.debug "Admin User ID from token: #{admin_user_id}"

        unless admin_user_id
          render json: {
            error: 'Unauthorized',
            message: 'Token không hợp lệ'
          }, status: :unauthorized
          return
        end
        
        @current_admin_user = AdminUser.find_by(id: admin_user_id)
        Rails.logger.debug "Current admin user found: #{@current_admin_user ? @current_admin_user.email : 'None'}"
        
        unless @current_admin_user
          render json: { 
            error: 'Unauthorized',
            message: 'Tài khoản admin không tồn tại'
          }, status: :unauthorized
        end
      end

      def current_admin_user
        @current_admin_user
      end
    end
  end
end

