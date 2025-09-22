module Api
  module V1
    class ContactProductRequestsController < ApplicationController
      def create
        @contact_request = ContactProductRequest.new(contact_request_params)
        if @contact_request.save
          # Send email to admin
          ContactProductRequestMailer.new_contact_request(@contact_request).deliver_later
          render json: {
            success: true,
            message: 'Thông tin đã được gửi thành công! Chúng tôi sẽ liên hệ với bạn sớm nhất.',
            data: {
              id: @contact_request.id,
              created_at: @contact_request.created_at
            }
          }, status: :created
        else
          render json: {
            success: false,
            message: 'Có lỗi xảy ra khi gửi thông tin',
            errors: @contact_request.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def contact_request_params
        params.require(:contact_product_request).permit(
          :name, :email, :phone, :product_id
        )
      end
    end
  end
end
