# Preview all emails at http://localhost:3000/rails/mailers/order_confirmation_mailer
class OrderConfirmationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_confirmation_mailer/confirmation
  def confirmation
    OrderConfirmationMailer.confirmation
  end

end
