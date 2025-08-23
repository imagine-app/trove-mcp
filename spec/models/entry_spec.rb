require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:vault) { create(:vault) }
  let(:mailbox) { create(:mailbox, vault: vault) }

  describe 'validations' do
    it 'is invalid without entriable' do
      entry = build(:entry, vault: vault, entriable: nil)
      expect(entry).not_to be_valid
    end
  end

  describe 'delegated types' do
    it 'accepts Entry::Email as entriable' do
      email = create(:email, mailbox: mailbox)
      entry = build(:entry, vault: vault, entriable: email)
      expect(entry).to be_valid
    end

    it 'accepts Entry::Message as entriable' do
      message = create(:message)
      entry = build(:entry, vault: vault, entriable: message)
      expect(entry).to be_valid
    end

    it 'accepts Entry::Link as entriable' do
      link = create(:link)
      entry = build(:entry, vault: vault, entriable: link)
      expect(entry).to be_valid
    end
  end

  describe 'associations with contexts' do
    it 'can be associated with contexts' do
      message = create(:message)
      entry = create(:entry, vault: vault, entriable: message)
      context = create(:context, vault: vault)

      entry.contexts << context
      expect(entry.contexts).to include(context)
    end

    it 'allows contexts to find associated entries' do
      message = create(:message)
      entry = create(:entry, vault: vault, entriable: message)
      context = create(:context, vault: vault)

      entry.contexts << context
      expect(context.entries).to include(entry)
    end
  end
end
