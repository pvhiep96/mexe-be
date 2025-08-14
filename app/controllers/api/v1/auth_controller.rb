module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate_user!, only: [:profile, :update_profile, :change_password]
      before_action :ensure_json_request
      
      def login
        user = User.find_by(email: params[:email])
        
        if user && user.authenticate(params[:password])
          token = JwtService.generate_user_token(user)
          
          render json: {
            success: true,
            message: 'Đăng nhập thành công',
            user: UserSerializer.new(user).serializable_hash,
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
          
          render json: {
            success: true,
            message: 'Đăng ký thành công',
            user: UserSerializer.new(user).serializable_hash,
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
        render json: {
          success: true,
          user: UserSerializer.new(current_user).serializable_hash
        }, status: :ok
      end
      
      def update_profile
        if current_user.update(profile_params)
          render json: {
            success: true,
            message: 'Cập nhật thông tin thành công',
            user: UserSerializer.new(current_user).serializable_hash
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