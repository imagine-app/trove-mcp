require 'rails_helper'

RSpec.describe Vault, type: :model do
  let(:vault) { create(:vault) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(vault).to be_valid
    end

    it 'is invalid without a name' do
      vault.name = nil
      expect(vault).not_to be_valid
    end
  end

  describe 'associations' do
    it 'can have memberships' do
      user = create(:user)
      membership = create(:membership, vault: vault, user: user)
      expect(vault.memberships).to include(membership)
    end

    it 'can have users through memberships' do
      user = create(:user)
      create(:membership, vault: vault, user: user)
      expect(vault.users).to include(user)
    end
  end
end