class Api::V1::ContactsController < Api::ApplicationController
  before_action :validate_contact_params

  def create
    begin
      ContactMailer.send_contact_info(contact_params).deliver_now

      render json: {
        message: "Email đã được gửi thành công!",
        status: "success"
      }, status: :ok
    rescue => e
      Rails.logger.error "Contact email error: #{e.message}"
      render json: {
        message: "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.",
        status: "error"
      }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :address, :product_name, :product_url)
  end

  def validate_contact_params
    unless params[:contact].present?
      render json: {
        message: "Thông tin liên hệ không được để trống",
        status: "error"
      }, status: :bad_request
      return
    end

    required_fields = [:name, :email, :phone, :address]
    missing_fields = required_fields.select { |field| contact_params[field].blank? }

    if missing_fields.any?
      render json: {
        message: "Các trường sau không được để trống: #{missing_fields.join(', ')}",
        status: "error"
      }, status: :bad_request
      return
    end

    # Validate email format
    unless contact_params[:email].match?(/\A[^@\s]+@[^@\s]+\z/)
      render json: {
        message: "Email không đúng định dạng",
        status: "error"
      }, status: :bad_request
      return
    end
  end
end