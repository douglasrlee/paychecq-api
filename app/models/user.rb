# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :password

  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  after_validation :encrypt_password, if: -> { password.present? }

  private

  def encrypt_password
    self.hashed_password = AuthenticationService.encrypt_secret(password)
  end
end
