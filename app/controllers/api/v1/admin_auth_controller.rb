module Api
  module V1
    class AdminAuthController < Api::ApplicationController
      skip_before_action :authenticate_user!, only: [:login]

      # POST /api/v1/admin_auth/login
      def login
        email = params[:email]
        password = params[:password]

        unless email.present? && password.present?
          render json: {
            success: false,
            error: 'Email và mật khẩu là bắt buộc'
          }, status: :bad_request
          return
        end

        admin_user = AdminUser.find_by(email: email.downcase)

        unless admin_user&.valid_password?(password)
          render json: {
            success: false,
            error: 'Email hoặc mật khẩu không đúng'
          }, status: :unauthorized
          return
        end

        unless admin_user.persisted?
          render json: {
            success: false,
            error: 'Tài khoản chưa được kích hoạt'
          }, status: :unauthorized
          return
        end

        # Generate JWT token
        token = JwtService.generate_admin_user_token(admin_user)

        render json: {
          success: true,
          data: {
            token: token,
            admin_user: {
              id: admin_user.id,
              email: admin_user.email,
              role: admin_user.role,
              client_name: admin_user.client_name,
              display_name: admin_user.display_name
            }
          },
          message: 'Đăng nhập thành công'
        }
      end

      # GET /api/v1/admin_auth/profile
      def profile
        render json: {
          success: true,
          data: {
            id: @current_admin_user.id,
            email: @current_admin_user.email,
            role: @current_admin_user.role,
            client_name: @current_admin_user.client_name,
            display_name: @current_admin_user.display_name,
            can_manage_products: @current_admin_user.can_manage_products?,
            can_manage_orders: @current_admin_user.can_manage_orders?,
            can_view_analytics: @current_admin_user.can_view_analytics?,
            can_approve_products: @current_admin_user.can_approve_products?,
            can_manage_admin_users: @current_admin_user.can_manage_admin_users?
          }
        }
      end

      # POST /api/v1/admin_auth/logout
      def logout
        # In a stateless JWT system, logout is typically handled client-side
        # by removing the token from storage
        render json: {
          success: true,
          message: 'Đăng xuất thành công'
        }
      end

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


