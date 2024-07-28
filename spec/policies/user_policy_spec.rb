# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:client) { create(:client) }

  permissions :create? do
    it 'grants access to Client type current_users' do
      expect(described_class).to permit(client, nil)
    end

    it 'does not grant access if current_user is nil' do
      expect(described_class).not_to permit(nil, nil)
    end
  end
end
