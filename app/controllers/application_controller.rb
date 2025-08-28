class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Skip CSRF protection for API endpoints
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  
  # JWT Authentication for API endpoints
  before_action :authenticate_user_from_token, if: -> { request.format.json? }
  
  private
  
  def authenticate_user_from_token
    token = extract_token_from_header
    return unless token
    
    user_id = JwtService.extract_user_id(token)
    @current_user = User.find_by(id: user_id) if user_id
  end
  
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
    unless current_user
      render json: { 
        error: 'Unauthorized',
        message: 'Vui lòng đăng nhập để tiếp tục'
      }, status: :unauthorized
    end
  end
  
  def ensure_json_request
    request.format = :json
  end
end