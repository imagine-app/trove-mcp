require 'rails_helper'

RSpec.describe "Api::Entries", type: :request do
  let(:user) { create(:user) }
  let(:vault) { create(:vault) }
  let!(:membership) { create(:membership, user: user, vault: vault, role: :manager) }
  let!(:message_entry) { create(:entry, :with_message, vault: vault) }
  let!(:email_entry) { create(:entry, :with_email, vault: vault) }

  before do
    sign_in_api(user)
  end

  describe "GET /api/vaults/:vault_id/entries" do
    it "returns vault's entries" do
      get api_vault_entries_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(2)
    end

    it "includes entry type information" do
      get api_vault_entries_path(vault), headers: { 'Accept' => 'application/json' }

      json_response = JSON.parse(response.body)
      entry = json_response.first
      expect(entry).to have_key('entriable_type')
      expect(entry['entriable_type']).to be_in([ 'Entry::Message', 'Entry::Email' ])
    end
  end

  describe "POST /api/vaults/:vault_id/entries" do
    context "with Entry::Message type" do
      let(:valid_params) do
        {
          entry: {
            title: "Test Message",
            description: "Test description",
            type: "Entry::Message",
            entriable_attributes: {
              text: "This is a test message"
            }
          }
        }
      end

      it "creates a new message entry" do
        expect {
          post api_vault_entries_path(vault), params: valid_params, headers: { 'Accept' => 'application/json' }
        }.to change(Entry, :count).by(1).and change(Entry::Message, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq("Test Message")
        expect(json_response['entriable_type']).to eq("Entry::Message")
      end
    end

    context "with Entry::Email type" do
      let(:valid_params) do
        {
          entry: {
            title: "Test Email",
            description: "Test description",
            type: "Entry::Email",
            entriable_attributes: {
              from: "sender@example.com",
              to: "recipient@example.com",
              subject: "Test Subject",
              body: "Test email body"
            }
          }
        }
      end

      it "creates a new email entry" do
        expect {
          post api_vault_entries_path(vault), params: valid_params, headers: { 'Accept' => 'application/json' }
        }.to change(Entry, :count).by(1).and change(Entry::Email, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq("Test Email")
        expect(json_response['entriable_type']).to eq("Entry::Email")
      end
    end

    context "with Entry::Link type" do
      let(:valid_params) do
        {
          entry: {
            title: "Test Link",
            description: "Test description",
            type: "Entry::Link",
            entriable_attributes: {
              url: "https://example.com",
              title: "Example Link"
            }
          }
        }
      end

      it "creates a new link entry" do
        expect {
          post api_vault_entries_path(vault), params: valid_params, headers: { 'Accept' => 'application/json' }
        }.to change(Entry, :count).by(1).and change(Entry::Link, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq("Test Link")
        expect(json_response['entriable_type']).to eq("Entry::Link")
      end
    end

    it "returns errors for invalid params" do
      post api_vault_entries_path(vault), params: { entry: { title: "" } }, headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('error')
    end
  end

  describe "PUT /api/vaults/:vault_id/entries/:id" do
    it "updates the entry" do
      put api_vault_entry_path(vault, message_entry),
          params: { entry: { title: "Updated Title" } },
          headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      message_entry.reload
      expect(message_entry.title).to eq("Updated Title")
    end
  end

  describe "DELETE /api/vaults/:vault_id/entries/:id" do
    it "deletes the entry" do
      expect {
        delete api_vault_entry_path(vault, message_entry), headers: { 'Accept' => 'application/json' }
      }.to change(Entry, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "authentication" do
    before do
      delete session_path(user.id)
    end

    it "requires authentication" do
      get api_vault_entries_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Authentication required")
    end
  end
end
