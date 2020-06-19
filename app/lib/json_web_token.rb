# lib/json_webtoken/json_web_token.rb
class JsonWebToken
  class << self
    def encode(payload, exp = 1.hour.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.credentials.jwt[:secret])
    end
 
    def decode(token)
      body = JWT.decode(token, Rails.application.credentials.jwt[:secret])[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature
      #handle expiration
      raise JWT::ExpiredSignature
    rescue
      nil
    end
  end
 end