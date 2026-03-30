require "rails_helper"

RSpec.describe "Companies API", type: :request do
  let(:user)    { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/companies" do
    before { create_list(:company, 4) }

    it "returns all companies with pagination" do
      get "/api/v1/companies", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:companies].length).to eq(4)
      expect(json[:meta]).to have_key(:total_count)
    end

    it "searches by name" do
      create(:company, name: "UniqueCorp India")
      get "/api/v1/companies?q=UniqueCorp", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:companies].length).to eq(1)
      expect(json[:companies][0][:name]).to eq("UniqueCorp India")
    end

    it "returns 401 without auth" do
      get "/api/v1/companies"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/companies/:id" do
    let(:company) { create(:company) }

    it "returns company with full details" do
      get "/api/v1/companies/#{company.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:company][:id]).to eq(company.id)
      expect(json[:company][:name]).to eq(company.name)
      expect(json[:company]).to have_key(:deals_count)
    end

    it "returns 404 for unknown company" do
      get "/api/v1/companies/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/companies" do
    let(:valid_params) do
      {
        name:     "Apex Technologies",
        industry: "Software",
        website:  "https://apex.io",
        city:     "Bangalore",
        country:  "India",
        size:     "large"
      }
    end

    it "creates a company" do
      expect {
        post "/api/v1/companies", params: valid_params.to_json, headers: headers
      }.to change(Company, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json[:company][:name]).to eq("Apex Technologies")
    end

    it "rejects duplicate company name" do
      create(:company, name: "Apex Technologies")
      post "/api/v1/companies", params: valid_params.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects missing name" do
      post "/api/v1/companies", params: { industry: "IT" }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/companies/:id" do
    let(:company) { create(:company) }

    it "updates the company" do
      put "/api/v1/companies/#{company.id}",
          params: { city: "Mumbai", size: "enterprise" }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:company][:city]).to eq("Mumbai")
    end
  end

  describe "DELETE /api/v1/companies/:id" do
    let!(:company) { create(:company) }

    it "deletes the company" do
      expect {
        delete "/api/v1/companies/#{company.id}", headers: headers
      }.to change(Company, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/companies/:id/contacts" do
    let(:company)  { create(:company) }
    before { create_list(:contact, 3, company: company) }

    it "returns all contacts of the company" do
      get "/api/v1/companies/#{company.id}/contacts", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:contacts].length).to eq(3)
      json[:contacts].each { |c| expect(c).to have_key(:full_name) }
    end
  end

  describe "GET /api/v1/companies/:id/deals" do
    let(:company) { create(:company) }
    before { create_list(:deal, 2, company: company, owner: user) }

    it "returns all deals of the company" do
      get "/api/v1/companies/#{company.id}/deals", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:deals].length).to eq(2)
    end
  end
end
