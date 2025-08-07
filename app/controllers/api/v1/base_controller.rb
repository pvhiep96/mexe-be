class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  private
  
  def render_success(data = nil, message = 'Thành công', status = :ok)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end
  
  def render_error(message = 'Có lỗi xảy ra', errors = nil, status = :unprocessable_entity)
    response = {
      success: false,
      message: message
    }
    response[:errors] = errors if errors.present?
    
    render json: response, status: status
  end
end 