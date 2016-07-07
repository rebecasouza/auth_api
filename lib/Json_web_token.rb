class JsonWebToken
  class << self
    # Authenticates user, generating a unique token based on the application's secret key
    def encode(payload, expiration = 24.hours.from_now)
      payload[:expiration] = expiration.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    # Checks if the user's token is present in each request, using the application's secret key to decode it
    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end