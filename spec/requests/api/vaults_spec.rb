require 'rails_helper'

RSpec.describe "Api::Vaults", type: :request do
  let(:user) { create(:user) }
  let(:vault) { create(:vault) }
  let!(:membership) { create(:membership, user: user, vault: vault, role: :manager) }

  before do
    # Simulate login
    post sessions_path, params: { session: { email: user.email, password: "password123" } }
  end

  describe "GET /api/vaults" do
    it "returns user's vaults" do
      get api_vaults_path, headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(1)
      expect(json_response.first['name']).to eq(vault.name)
    end
  end

  describe "POST /api/vaults" do
    let(:valid_params) { { vault: { name: "Test Vault" } } }

    it "creates a new vault" do
      expect {
        post api_vaults_path, params: valid_params, headers: { 'Accept' => 'application/json' }
      }.to change(Vault, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq("Test Vault")
    end

    it "returns errors for invalid params" do
      post api_vaults_path, params: { vault: { name: "" } }, headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
    end
  end

  describe "PUT /api/vaults/:id" do
    it "updates the vault" do
      put api_vault_path(vault), params: { vault: { name: "Updated Name" } },
          headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      vault.reload
      expect(vault.name).to eq("Updated Name")
    end
  end

  describe "DELETE /api/vaults/:id" do
    it "deletes the vault" do
      expect {
        delete api_vault_path(vault), headers: { 'Accept' => 'application/json' }
      }.to change(Vault, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "authentication" do
    before do
      # Logout
      delete session_path(user.id)
    end

    it "requires authentication" do
      get api_vaults_path, headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Authentication required")
    end
  end
end
