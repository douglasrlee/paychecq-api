# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenService do
  let(:user) { create(:user) }
  let(:client) { create(:client) }

  describe '.access_token' do
    before do
      allow(JwtService).to receive(:encode).and_return('encoded_jwt')
    end

    it 'calls the JwtService' do
      Timecop.freeze do
        described_class.access_token(user, client)

        expect(JwtService).to have_received(:encode).with({
                                                            sub: user.id,
                                                            aud: client.id,
                                                            exp: Time.now.utc.to_i + (60 * 60 * 24),
                                                            typ: 'access_token',
                                                            iss: ENV.fetch('PAYCHECQ_API_HOST')
                                                          })
      end
    end

    it 'returns the encode jwt' do
      expect(described_class.access_token(user, client)).to eq('encoded_jwt')
    end
  end

  describe '.id_token' do
    before do
      allow(JwtService).to receive(:encode).and_return('encoded_jwt')
    end

    it 'calls the JwtService' do
      Timecop.freeze do
        described_class.id_token(user, client)

        expect(JwtService).to have_received(:encode).with({
                                                            sub: user.id,
                                                            aud: client.id,
                                                            exp: Time.now.utc.to_i + (60 * 60 * 24 * 30),
                                                            typ: 'id_token',
                                                            iss: ENV.fetch('PAYCHECQ_API_HOST'),
                                                            name: user.name,
                                                            picture: "https://gravatar.com/avatar/#{Digest::SHA256.hexdigest(user.email)}?d=mp",
                                                            email: user.email,
                                                            updated_at: user.updated_at.to_i
                                                          })
      end
    end

    it 'returns the encode jwt' do
      expect(described_class.id_token(user, client)).to eq('encoded_jwt')
    end
  end
end
