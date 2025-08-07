require 'jwt'

class Api::V1::AuthController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:change_password, :profile, :update_profile]

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      user.update(last_login_at: Time.current)
      
      render json: {
        success: true,
        message: 'Đăng nhập thành công',
        data: {
          user: {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            phone: user.phone,
            avatar: user.avatar,
            is_verified: user.is_verified
          },
          token: generate_jwt_token(user)
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: 'Email hoặc mật khẩu không đúng'
      }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/register
  def register
    # Kiểm tra email đã tồn tại chưa
    if User.exists?(email: params[:email])
      render json: {
        success: false,
        message: 'Email đã được sử dụng'
      }, status: :unprocessable_entity
      return
    end

    # Tạo user mới
    user = User.new(
      email: params[:email],
      full_name: params[:full_name],
      phone: params[:phone],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if user.save
      render json: {
        success: true,
        message: 'Đăng ký thành công',
        data: {
          user: {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            phone: user.phone,
            avatar: user.avatar,
            is_verified: user.is_verified
          },
          token: generate_jwt_token(user)
        }
      }, status: :created
    else
      render json: {
        success: false,
        message: 'Có lỗi xảy ra khi đăng ký',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/change_password
  def change_password
    user = current_user
    
    # Kiểm tra mật khẩu hiện tại
    unless user.authenticate(params[:current_password])
      render json: {
        success: false,
        message: 'Mật khẩu hiện tại không đúng'
      }, status: :unauthorized
      return
    end

    # Cập nhật mật khẩu mới
    if user.update(
      password: params[:new_password],
      password_confirmation: params[:new_password_confirmation]
    )
      render json: {
        success: true,
        message: 'Đổi mật khẩu thành công'
      }, status: :ok
    else
      render json: {
        success: false,
        message: 'Có lỗi xảy ra khi đổi mật khẩu',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/auth/profile
  def profile
    render json: {
      success: true,
      data: {
        user: {
          id: current_user.id,
          email: current_user.email,
          full_name: current_user.full_name,
          phone: current_user.phone,
          avatar: current_user.avatar,
          date_of_birth: current_user.date_of_birth,
          gender: current_user.gender,
          is_verified: current_user.is_verified,
          last_login_at: current_user.last_login_at
        }
      }
    }, status: :ok
  end

  # PUT /api/v1/auth/update_profile
  def update_profile
    user = current_user
    
    # Các trường có thể update
    update_params = params.permit(:full_name, :phone, :avatar, :date_of_birth, :gender)
    
    # Validate date_of_birth nếu có
    if update_params[:date_of_birth].present?
      begin
        Date.parse(update_params[:date_of_birth])
      rescue ArgumentError
        render json: {
          success: false,
          message: 'Ngày sinh không hợp lệ'
        }, status: :unprocessable_entity
        return
      end
    end
    
    # Validate gender nếu có
    if update_params[:gender].present? && !User.genders.key?(update_params[:gender])
      render json: {
        success: false,
        message: 'Giới tính không hợp lệ'
      }, status: :unprocessable_entity
      return
    end
    
    if user.update(update_params)
      render json: {
        success: true,
        message: 'Cập nhật thông tin thành công',
        data: {
          user: {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            phone: user.phone,
            avatar: user.avatar,
            date_of_birth: user.date_of_birth,
            gender: user.gender,
            is_verified: user.is_verified,
            last_login_at: user.last_login_at
          }
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: 'Có lỗi xảy ra khi cập nhật thông tin',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def generate_jwt_token(user)
    JwtService.generate_user_token(user)
  end
end 