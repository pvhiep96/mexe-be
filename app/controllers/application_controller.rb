class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # CSRF protection - use exception for web, null_session for API
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  
  private
  
  def authenticate_user_from_token
    token = extract_token_from_header
    Rails.logger.debug "Auth Header Token: #{token ? 'Present' : 'Missing'}"
    return unless token
    
    user_id = JwtService.extract_user_id(token)
    Rails.logger.debug "User ID from token: #{user_id}"
    
    @current_user = User.find_by(id: user_id) if user_id
    Rails.logger.debug "Current user found: #{@current_user ? @current_user.email : 'None'}"
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