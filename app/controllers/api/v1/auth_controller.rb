module Api
  module V1
    class AuthController < Api::ApplicationController
      before_action :authenticate_user!, only: [:update_profile, :change_password]
      before_action :ensure_json_request
      # skip_before_action :authenticate_user_from_token, only: [:login, :register, :profile]

      def login
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          token = JwtService.generate_user_token(user)
          
          user_data = UserSerializer.new(user).serializable_hash
          # Extract actual user data from serializer
          actual_user_data = user_data.is_a?(Hash) && user_data[:data] ? user_data[:data] : user_data

          render json: {
            success: true,
            message: 'Đăng nhập thành công',
            user: actual_user_data,
            token: token
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Email hoặc mật khẩu không đúng',
            errors: ['Email hoặc mật khẩu không đúng']
          }, status: :unauthorized
        end
      end

      def register
        user = User.new(user_params)

        if user.save
          token = JwtService.generate_user_token(user)
          
          user_data = UserSerializer.new(user).serializable_hash
          actual_user_data = user_data.is_a?(Hash) && user_data[:data] ? user_data[:data] : user_data

          render json: {
            success: true,
            message: 'Đăng ký thành công',
            user: actual_user_data,
            token: token
          }, status: :created
        else
          render json: {
            success: false,
            message: 'Đăng ký thất bại',
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def profile
        # Manually verify token for profile endpoint
        token = extract_token_from_header
        
        unless token
          render json: {
            success: false,
            message: 'Token không được cung cấp',
            errors: ['Token không được cung cấp']
          }, status: :unauthorized
          return
        end

        begin
          user_id = JwtService.extract_user_id(token)
          user = User.find_by(id: user_id)
          
          unless user
            render json: {
              success: false,
              message: 'Người dùng không tồn tại',
              errors: ['Người dùng không tồn tại']
            }, status: :unauthorized
            return
          end

          user_data = UserSerializer.new(user).serializable_hash
          actual_user_data = user_data.is_a?(Hash) && user_data[:data] ? user_data[:data] : user_data
          
          render json: {
            success: true,
            user: actual_user_data
          }, status: :ok
        rescue => e
          Rails.logger.error "Profile verification error: #{e.message}"
          render json: {
            success: false,
            message: 'Token không hợp lệ',
            errors: ['Token không hợp lệ']
          }, status: :unauthorized
        end
      end

      def update_profile
        if current_user.update(profile_params)
          user_data = UserSerializer.new(current_user).serializable_hash
          actual_user_data = user_data.is_a?(Hash) && user_data[:data] ? user_data[:data] : user_data
          
          render json: {
            success: true,
            message: 'Cập nhật thông tin thành công',
            user: actual_user_data
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Cập nhật thông tin thất bại',
            errors: current_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def change_password
        if current_user.authenticate(params[:current_password])
          if current_user.update(password: params[:new_password])
            render json: {
              success: true,
              message: 'Đổi mật khẩu thành công'
            }, status: :ok
          else
            render json: {
              success: false,
              message: 'Đổi mật khẩu thất bại',
              errors: current_user.errors.full_messages
            }, status: :unprocessable_entity
          end
        else
          render json: {
            success: false,
            message: 'Mật khẩu hiện tại không đúng',
            errors: ['Mật khẩu hiện tại không đúng']
          }, status: :unauthorized
        end
      end

      def logout
        # Since we're using JWT, logout is mainly handled on frontend
        # by removing the token from storage
        render json: {
          success: true,
          message: 'Đăng xuất thành công'
        }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :full_name, :phone, :address)
      end

      def profile_params
        params.require(:user).permit(:full_name, :phone, :date_of_birth, :address)
      end
    end
  end
end
