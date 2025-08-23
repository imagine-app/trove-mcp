require 'rails_helper'

RSpec.describe "Api::Mailboxes", type: :request do
  let(:user) { create(:user) }
  let(:vault) { create(:vault) }
  let!(:membership) { create(:membership, user: user, vault: vault, role: :manager) }
  let!(:mailbox) { create(:mailbox, vault: vault) }

  before do
    post sessions_path, params: { session: { email: user.email, password: "password123" } }
  end

  describe "GET /api/vaults/:vault_id/mailboxes" do
    it "returns vault's mailboxes" do
      get api_vault_mailboxes_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(1)
      expect(json_response.first['id']).to eq(mailbox.id)
    end

    it "includes basic mailbox details" do
      get api_vault_mailboxes_path(vault), headers: { 'Accept' => 'application/json' }

      json_response = JSON.parse(response.body)
      mailbox_data = json_response.first
      expect(mailbox_data).to have_key('vault_id')
      expect(mailbox_data).to have_key('created_at')
      expect(mailbox_data).to have_key('updated_at')
    end
  end

  describe "POST /api/vaults/:vault_id/mailboxes" do
    let(:valid_params) do
      {
        mailbox: {}
      }
    end

    it "creates a new mailbox" do
      expect {
        post api_vault_mailboxes_path(vault), params: valid_params, headers: { 'Accept' => 'application/json' }
      }.to change(Mailbox, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['vault_id']).to eq(vault.id)
    end
  end

  describe "GET /api/vaults/:vault_id/mailboxes/:id" do
    it "returns the mailbox" do
      get api_vault_mailbox_path(vault, mailbox), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(mailbox.id)
      expect(json_response['vault_id']).to eq(vault.id)
    end
  end

  describe "PUT /api/vaults/:vault_id/mailboxes/:id" do
    it "updates the mailbox" do
      put api_vault_mailbox_path(vault, mailbox),
          params: { mailbox: {} },
          headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /api/vaults/:vault_id/mailboxes/:id" do
    it "deletes the mailbox" do
      expect {
        delete api_vault_mailbox_path(vault, mailbox), headers: { 'Accept' => 'application/json' }
      }.to change(Mailbox, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "authorization" do
    let(:other_user) { create(:user) }
    let(:other_vault) { create(:vault) }
    let!(:other_membership) { create(:membership, user: other_user, vault: other_vault, role: :reader) }
    let!(:other_mailbox) { create(:mailbox, vault: other_vault) }

    it "restricts access to mailboxes from other vaults" do
      get api_vault_mailbox_path(other_vault, other_mailbox), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:forbidden)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Access denied")
    end
  end

  describe "authentication" do
    before do
      delete session_path(user.id)
    end

    it "requires authentication" do
      get api_vault_mailboxes_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Authentication required")
    end
  end
end
