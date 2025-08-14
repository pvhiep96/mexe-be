class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base || 'your-secret-key-here'
  ALGORITHM = 'HS256'
  TOKEN_EXPIRATION = 24.hours

  def self.encode(payload)
    # Add expiration and issued time
    payload = payload.merge({
      exp: TOKEN_EXPIRATION.from_now.to_i,
      iat: Time.current.to_i
    })
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end

  def self.valid_token?(token)
    decoded = decode(token)
    decoded.present?
  end

  def self.extract_user_id(token)
    decoded = decode(token)
    decoded&.first&.dig('user_id')
  end

  def self.generate_user_token(user)
    payload = {
      user_id: user.id,
      email: user.email
    }
    encode(payload)
  end
end