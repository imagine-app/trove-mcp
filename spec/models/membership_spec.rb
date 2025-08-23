require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:membership) { create(:membership) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(membership).to be_valid
    end

    it 'is invalid without a role' do
      membership.role = nil
      expect(membership).not_to be_valid
    end

    it 'enforces uniqueness of user per vault' do
      user = create(:user)
      vault = create(:vault)
      create(:membership, user: user, vault: vault)

      duplicate = build(:membership, user: user, vault: vault)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'enums' do
    it 'defines reader and manager roles' do
      expect(described_class.roles).to eq({ 'reader' => 0, 'manager' => 1 })
    end
  end
end
