module PaymentOptionsSerializable
  extend ActiveSupport::Concern

  def payment_options_attributes
    {
      full_payment_transfer: full_payment_transfer,
      full_payment_discount_percentage: full_payment_discount_percentage,
      partial_advance_payment: partial_advance_payment,
      advance_payment_percentage: advance_payment_percentage,
      advance_payment_discount_percentage: advance_payment_discount_percentage
    }
  end

  # Check if product has any special payment options configured
  def has_payment_options?
    full_payment_transfer? || partial_advance_payment?
  end

  # Get the primary payment option type
  def primary_payment_option
    return 'full_payment' if full_payment_transfer?
    return 'partial_advance' if partial_advance_payment?
    'regular'
  end
end