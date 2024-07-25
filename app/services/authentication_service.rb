# frozen_string_literal: true

require 'bcrypt'

class AuthenticationService
  include BCrypt

  def self.encrypt_secret(secret, salt = nil)
    salt ||= BCrypt::Engine.generate_salt

    BCrypt::Engine.hash_secret(secret, salt)
  end

  def self.valid_secret?(secret, hashed_secret)
    password_salt = BCrypt::Password.new(hashed_secret).salt

    encrypt_secret(secret, password_salt) == hashed_secret
  end
end
