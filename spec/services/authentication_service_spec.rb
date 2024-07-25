# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService do
  describe '.encrypt_secret' do
    it 'creates a hashed secret from the passed in secret' do
      allow(BCrypt::Engine).to receive_messages(generate_salt: 'salt', hash_secret: 'hashed_secret')

      described_class.encrypt_secret('secret')

      expect(BCrypt::Engine).to have_received(:hash_secret).with('secret', 'salt')
    end

    it 'returns a bcrypt hashed secret' do
      allow(BCrypt::Engine).to receive(:hash_secret).and_return('hashed_secret')

      expect(described_class.encrypt_secret('secret')).to eq('hashed_secret')
    end
  end

  describe '.valid_secret?' do
    it 'returns true if the given secret encrypts to the given secret digest' do
      hashed_secret = described_class.encrypt_secret('secret')

      expect(described_class.valid_secret?('secret', hashed_secret)).to be(true)
    end

    it 'returns false if the given secret encrypts to the given secret digest' do
      hashed_secret = described_class.encrypt_secret('secret')

      expect(described_class.valid_secret?('nope', hashed_secret)).to be(false)
    end
  end
end
