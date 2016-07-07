# Authorize requests by decoding the tokens from their headers
class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = { })
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  # Returns the user if the token is valid
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  # Decodes the token from http_auth_header and retrieves the user's ID
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Extracts the token from the authorization header
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end