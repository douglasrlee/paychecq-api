# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  let(:client) { create(:client) }

  permissions :create? do
    it 'grants access to present users' do
      expect(described_class).to permit(client, nil)
    end

    it 'does not grant access if user is not present' do
      expect(described_class).not_to permit(nil, nil)
    end
  end

  permissions :index?, :show?, :new?, :create?, :update?, :destroy?, :edit? do
    it 'does not grant access' do
      expect(described_class).not_to permit(nil, nil)
    end
  end

  describe 'scope' do
    describe '.resolve' do
      it 'raises NoMethodError' do
        expect do
          described_class::Scope.new(nil, nil).resolve
        end.to raise_error(NoMethodError).with_message('You must define #resolve in ApplicationPolicy::Scope')
      end
    end
  end
end
