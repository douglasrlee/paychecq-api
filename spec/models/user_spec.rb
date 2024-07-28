# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'callbacks' do
    describe '.encrypt_password' do
      context 'when password is blank' do
        it 'does not call encrypt_secret on the AuthenticationService' do
          user.password = nil

          allow(AuthenticationService).to receive(:encrypt_secret)

          user.save!

          expect(AuthenticationService).not_to have_received(:encrypt_secret)
        end
      end

      context 'when password is not blank' do
        it 'calls encrypt_secret on the AuthenticationService' do
          user.password = Faker::Internet.password

          allow(AuthenticationService).to receive(:encrypt_secret).and_return(user.password)

          user.save!

          expect(AuthenticationService).to have_received(:encrypt_secret).with(user.password)
        end
      end
    end
  end
end
