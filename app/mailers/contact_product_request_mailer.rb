class ContactProductRequestMailer < ApplicationMailer
  def new_contact_request(contact_request)
    @contact_request = contact_request
    @product = contact_request.product
    @admin_email = ENV['ADMIN_EMAIL']
    mail(
      to: @admin_email,
      subject: "Yêu cầu thông tin sản phẩm: #{@product.name} - từ #{@contact_request.name}",
      reply_to: @contact_request.email
    )
  end
end
