require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    context "when not authenticated" do
      it "returns http success" do
        get "/users/new"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /users" do
    it "creates user with valid params" do
      post "/users", params: { user: { email_address: "test@example.com", password: "password123", password_confirmation: "password123" } }
      expect(response).to have_http_status(:redirect)
    end
  end
end
