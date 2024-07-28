# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtService do
  describe '.encode' do
    it 'uses correct secret' do
      expect do
        JWT.decode(described_class.encode({}), Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      end.not_to raise_error
    end

    it 'adds default claims to body claims' do
      Timecop.freeze do
        jwt = described_class.encode({})

        decoded_jwt_body = JWT.decode(
          jwt, Rails.application.credentials.secret_key_base, false, algorithm: 'HS256'
        ).first

        expect(decoded_jwt_body['jti']).not_to be_nil
        expect(decoded_jwt_body['iat']).to eq(Time.now.utc.to_i)
        expect(decoded_jwt_body['nbf']).to eq(Time.now.utc.to_i)
      end
    end

    it 'adds header claims' do
      jwt = described_class.encode({})

      decoded_jwt_headers = JWT.decode(
        jwt, Rails.application.credentials.secret_key_base, false, algorithm: 'HS256'
      ).second

      expect(decoded_jwt_headers['alg']).to eq('HS256')
      expect(decoded_jwt_headers['typ']).to eq('JWT')
    end

    it 'adds passed in payload to body claims' do
      jwt = described_class.encode({ test: 'test' })

      decoded_jwt_body = JWT.decode(
        jwt, Rails.application.credentials.secret_key_base, false, algorithm: 'HS256'
      ).first

      expect(decoded_jwt_body['test']).to eq('test')
    end
  end

  describe '.decode' do
    it 'correctly validates the correct secret was used' do
      expect do
        described_class.decode(described_class.encode({}))
      end.not_to raise_error

      expect do
        described_class.decode(
          JWT.encode({}, 'bad', 'HS256')
        )
      end.to raise_error(JWT::VerificationError)
    end

    it 'returns decoded JWT body' do
      Timecop.freeze do
        decoded_jwt_body = described_class.decode(described_class.encode({})).first

        expect(decoded_jwt_body['jti']).not_to be_nil
        expect(decoded_jwt_body['iat']).to eq(Time.now.utc.to_i)
        expect(decoded_jwt_body['nbf']).to eq(Time.now.utc.to_i)
      end
    end

    it 'returns decoded JWT headers' do
      decoded_jwt_headers = described_class.decode(described_class.encode({})).second

      expect(decoded_jwt_headers['alg']).to eq('HS256')
      expect(decoded_jwt_headers['typ']).to eq('JWT')
    end
  end
end
