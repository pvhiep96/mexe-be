module Api
  class ApplicationController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    private

    def extract_token_from_header
      auth_header = request.headers['Authorization']
      return nil unless auth_header

      # Extract token from "Bearer TOKEN" format
      auth_header.split(' ').last if auth_header.start_with?('Bearer ')
    end

    def current_user
      @current_user
    end

    def authenticate_user!
      # Extract and verify token
      token = extract_token_from_header
      Rails.logger.debug "Auth Header Token: #{token ? 'Present' : 'Missing'}"

      unless token
        render json: {
          error: 'Unauthorized',
          message: 'Token không được cung cấp'
        }, status: :unauthorized
        return
      end

      # Verify token and get user
      user_id = JwtService.extract_user_id(token)
      Rails.logger.debug "User ID from token: #{user_id}"

      unless user_id
        render json: {
          error: 'Unauthorized',
          message: 'Token không hợp lệ'
        }, status: :unauthorized
        return
      end

      @current_user = User.find_by(id: user_id)
      Rails.logger.debug "Current user found: #{@current_user ? @current_user.email : 'None'}"

      unless @current_user
        render json: {
          error: 'Unauthorized',
          message: 'Người dùng không tồn tại'
        }, status: :unauthorized
      end
    end
  end
end
