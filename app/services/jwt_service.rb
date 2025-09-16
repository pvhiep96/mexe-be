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
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    Rails.logger.debug "JWT Decode successful: #{decoded}"
    decoded
  rescue JWT::ExpiredSignature => e
    Rails.logger.error "JWT Expired: #{e.message}"
    nil
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
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

  def self.extract_admin_user_id(token)
    decoded = decode(token)
    decoded&.first&.dig('admin_user_id')
  end

  def self.generate_user_token(user)
    payload = {
      user_id: user.id,
      email: user.email
    }
    encode(payload)
  end

  def self.generate_admin_user_token(admin_user)
    payload = {
      admin_user_id: admin_user.id,
      email: admin_user.email,
      role: admin_user.role
    }
    encode(payload)
  end
end