require 'rails_helper'

RSpec.describe "Api::Contexts", type: :request do
  let(:user) { create(:user) }
  let(:vault) { create(:vault) }
  let!(:membership) { create(:membership, user: user, vault: vault, role: :manager) }
  let!(:context) { create(:context, vault: vault) }

  before do
    post sessions_path, params: { session: { email: user.email, password: "password123" } }
  end

  describe "GET /api/vaults/:vault_id/contexts" do
    it "returns vault's contexts" do
      get api_vault_contexts_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(1)
      expect(json_response.first['name']).to eq(context.name)
    end

    it "includes context details" do
      get api_vault_contexts_path(vault), headers: { 'Accept' => 'application/json' }

      json_response = JSON.parse(response.body)
      context_data = json_response.first
      expect(context_data).to have_key('description')
      expect(context_data).to have_key('autotag')
      expect(context_data).to have_key('entries_count')
    end
  end

  describe "POST /api/vaults/:vault_id/contexts" do
    let(:valid_params) do
      {
        context: {
          name: "Test Context",
          description: "Test description",
          autotag: true
        }
      }
    end

    it "creates a new context" do
      expect {
        post api_vault_contexts_path(vault), params: valid_params, headers: { 'Accept' => 'application/json' }
      }.to change(Context, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq("Test Context")
      expect(json_response['autotag']).to be true
    end

    it "returns errors for invalid params" do
      post api_vault_contexts_path(vault), params: { context: { name: "" } }, headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
    end
  end

  describe "GET /api/vaults/:vault_id/contexts/:id" do
    it "returns the context" do
      get api_vault_context_path(vault, context), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(context.id)
      expect(json_response['name']).to eq(context.name)
    end
  end

  describe "PUT /api/vaults/:vault_id/contexts/:id" do
    it "updates the context" do
      put api_vault_context_path(vault, context),
          params: { context: { name: "Updated Context" } },
          headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      context.reload
      expect(context.name).to eq("Updated Context")
    end

    it "updates autotag setting" do
      put api_vault_context_path(vault, context),
          params: { context: { autotag: !context.autotag } },
          headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:success)
      context.reload
      expect(context.autotag).to eq(!context.autotag)
    end
  end

  describe "DELETE /api/vaults/:vault_id/contexts/:id" do
    it "deletes the context" do
      expect {
        delete api_vault_context_path(vault, context), headers: { 'Accept' => 'application/json' }
      }.to change(Context, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "authorization" do
    let(:other_user) { create(:user) }
    let(:other_vault) { create(:vault) }
    let!(:other_membership) { create(:membership, user: other_user, vault: other_vault, role: :reader) }
    let!(:other_context) { create(:context, vault: other_vault) }

    it "restricts access to contexts from other vaults" do
      get api_vault_context_path(other_vault, other_context), headers: { 'Accept' => 'application/json' }

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
      get api_vault_contexts_path(vault), headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Authentication required")
    end
  end
end
