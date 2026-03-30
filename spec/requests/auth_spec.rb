require "rails_helper"

RSpec.describe "Auth API", type: :request do
  describe "POST /api/v1/auth/signup" do
    let(:valid_params) do
      {
        name: "Prashant Dixit",
        email: "prashant@test.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end

    context "with valid params" do
      it "creates a user and returns a token" do
        post "/api/v1/auth/signup", params: valid_params.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:created)
        expect(json[:token]).to be_present
        expect(json[:user][:email]).to eq("prashant@test.com")
      end
    end

    context "with duplicate email" do
      before { create(:user, email: "prashant@test.com") }

      it "returns unprocessable entity" do
        post "/api/v1/auth/signup", params: valid_params.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with missing fields" do
      it "returns an error" do
        post "/api/v1/auth/signup", params: { email: "x@x.com" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "login@test.com", password: "secret123") }

    context "with correct credentials" do
      it "returns a JWT token" do
        post "/api/v1/auth/login",
             params: { email: "login@test.com", password: "secret123" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:ok)
        expect(json[:token]).to be_present
        expect(json[:user][:email]).to eq("login@test.com")
      end
    end

    context "with wrong password" do
      it "returns unauthorized" do
        post "/api/v1/auth/login",
             params: { email: "login@test.com", password: "wrongpass" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with unknown email" do
      it "returns not found" do
        post "/api/v1/auth/login",
             params: { email: "nobody@test.com", password: "pass" }.to_json,
             headers: { "Content-Type" => "application/json" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/v1/auth/me" do
    let(:user) { create(:user) }

    it "returns the current user when authenticated" do
      get "/api/v1/auth/me", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json[:user][:id]).to eq(user.id)
    end

    it "returns unauthorized without a token" do
      get "/api/v1/auth/me"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
