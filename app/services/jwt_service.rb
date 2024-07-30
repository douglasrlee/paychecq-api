# frozen_string_literal: true

require 'jwt'

class JwtService
  def self.encode(payload)
    now = Time.now.utc.to_i

    JWT.encode(payload.merge({
                               jti: SecureRandom.uuid,
                               iat: now,
                               nbf: now
                             }), key, 'HS256', { typ: 'JWT' })
  end

  def self.decode(token)
    JWT.decode(token, key, true, algorithm: 'HS256')
  end

  def self.key
    if Rails.application.credentials.secret_key_base.nil?
      'password' if ENV.fetch('CI')
    else
      Rails.application.credentials.secret_key_base
    end
  end

  private_class_method :key
end
