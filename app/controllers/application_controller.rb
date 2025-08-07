class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # JWT Authentication - chỉ áp dụng cho các endpoint cần authentication
  before_action :authenticate_user_from_token!, if: :api_request_requires_auth?
  
  private
  
  def api_request_requires_auth?
    request.path.start_with?('/api/') && 
    !request.path.include?('/auth/login') && 
    !request.path.include?('/auth/register')
  end
  
  def authenticate_user_from_token!
    token = extract_token_from_header
    
    if token
      user_id = JwtService.extract_user_id(token)
      if user_id
        @current_user = User.find(user_id)
      else
        render json: { success: false, message: 'Token không hợp lệ' }, status: :unauthorized
      end
    else
      render json: { success: false, message: 'Token không được cung cấp' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Người dùng không tồn tại' }, status: :unauthorized
  end
  
  def extract_token_from_header
    auth_header = request.headers['Authorization']
    if auth_header && auth_header.start_with?('Bearer ')
      auth_header.split(' ').last
    end
  end
  
  def current_user
    @current_user
  end
  
  def authenticate_user!
    unless current_user
      render json: { success: false, message: 'Yêu cầu đăng nhập' }, status: :unauthorized
    end
  end
end
