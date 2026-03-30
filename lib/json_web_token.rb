class JsonWebToken
  SECRET_KEY = ENV.fetch("JWT_SECRET", "crm_dev_secret_key_change_in_production_#{Rails.application.secret_key_base.first(20)}")
  EXPIRY     = 24.hours

  def self.encode(payload, exp = EXPIRY.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    raise ExceptionHandler::ExpiredToken, "Token expired. Please log in again."
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
