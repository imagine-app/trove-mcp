require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /session/new" do
    it "returns http success" do
      get "/session/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /session" do
    it "creates session with valid credentials" do
      user = create(:user, password: "password123")
      post "/session", params: { email_address: user.email_address, password: "password123" }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "DELETE /session" do
    it "destroys session" do
      delete "/session"
      expect(response).to have_http_status(:redirect)
    end
  end
end
