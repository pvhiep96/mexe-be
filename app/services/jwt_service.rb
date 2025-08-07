class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || 'your-secret-key-here'
  ALGORITHM = 'HS256'

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end

  def self.generate_user_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i,
      iat: Time.current.to_i
    }
    encode(payload)
  end

  def self.valid_token?(token)
    decode(token).present?
  end

  def self.extract_user_id(token)
    decoded = decode(token)
    decoded&.first&.dig('user_id')
  end
end 