# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client do
  subject(:client) { create(:client) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'callbacks' do
    describe 'encrypt_secret' do
      context 'when secret is blank' do
        it 'does not call encrypt_secret on the AuthenticationService' do
          client.secret = nil

          allow(AuthenticationService).to receive(:encrypt_secret)

          client.save!

          expect(AuthenticationService).not_to have_received(:encrypt_secret)
        end
      end

      context 'when secret is not blank' do
        it 'calls encrypt_secret on the AuthenticationService' do
          client.secret = SecureRandom.uuid

          allow(AuthenticationService).to receive(:encrypt_secret).and_return(client.secret)

          client.save!

          expect(AuthenticationService).to have_received(:encrypt_secret).with(client.secret)
        end
      end
    end
  end
end
