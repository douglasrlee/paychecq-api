# frozen_string_literal: true

require 'jwt'

class JwtService
  def self.encode(payload)
    now = Time.now.utc.to_i

    JWT.encode(payload.merge({
                               jti: SecureRandom.uuid,
                               iat: now,
                               nbf: now
                             }), Rails.application.credentials.secret_key_base, 'HS256', { typ: 'JWT' })
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
  end
end
