# frozen_string_literal: true

class Client < ApplicationRecord
  attr_accessor :secret

  validates :name, presence: true
  validates :name, uniqueness: true

  after_validation :encrypt_secret, if: -> { secret.present? }

  private

  def encrypt_secret
    self.hashed_secret = AuthenticationService.encrypt_secret(secret)
  end
end
