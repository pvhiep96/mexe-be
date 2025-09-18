class ContactMailer < ApplicationMailer
  def send_contact_info(contact_data)
    @contact = contact_data
    @name = contact_data[:name]
    @email = contact_data[:email]
    @phone = contact_data[:phone]
    @address = contact_data[:address]
    @product_name = contact_data[:product_name]
    @product_url = contact_data[:product_url]

    mail(
      to: @email,
      subject: 'Thông tin sản phẩm từ Mexe Store'
    )
  end
end