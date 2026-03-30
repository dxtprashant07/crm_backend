require "rails_helper"

RSpec.describe "Contacts API", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/contacts" do
    before { create_list(:contact, 5) }

    it "returns all contacts with pagination meta" do
      get "/api/v1/contacts", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:contacts].length).to eq(5)
      expect(json[:meta]).to have_key(:total_count)
    end

    it "supports search by name" do
      create(:contact, first_name: "Unique", last_name: "Person")
      get "/api/v1/contacts?q=Unique", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:contacts].length).to eq(1)
      expect(json[:contacts][0][:full_name]).to include("Unique")
    end

    it "filters by status" do
      create(:contact, :customer)
      get "/api/v1/contacts?status=customer", headers: headers

      expect(response).to have_http_status(:ok)
      json[:contacts].each { |c| expect(c[:status]).to eq("customer") }
    end

    it "returns 401 without auth" do
      get "/api/v1/contacts"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/contacts/:id" do
    let(:contact) { create(:contact, :with_company) }

    it "returns the contact with full details" do
      get "/api/v1/contacts/#{contact.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:contact][:id]).to eq(contact.id)
      expect(json[:contact][:full_name]).to eq(contact.full_name)
      expect(json[:contact]).to have_key(:deals_count)
      expect(json[:contact]).to have_key(:activities_count)
    end

    it "returns 404 for missing contact" do
      get "/api/v1/contacts/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/contacts" do
    let(:company) { create(:company) }
    let(:valid_params) do
      {
        first_name: "Rahul",
        last_name: "Verma",
        email: "rahul@test.com",
        phone: "9876543210",
        job_title: "CTO",
        status: "lead",
        source: "referral",
        company_id: company.id
      }
    end

    it "creates a new contact" do
      expect {
        post "/api/v1/contacts", params: valid_params.to_json, headers: headers
      }.to change(Contact, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json[:contact][:email]).to eq("rahul@test.com")
    end

    it "returns 422 with invalid data" do
      post "/api/v1/contacts", params: { first_name: "" }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/contacts/:id" do
    let(:contact) { create(:contact) }

    it "updates the contact" do
      put "/api/v1/contacts/#{contact.id}",
          params: { job_title: "VP Engineering" }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:contact][:job_title]).to eq("VP Engineering")
    end
  end

  describe "DELETE /api/v1/contacts/:id" do
    let!(:contact) { create(:contact) }

    it "deletes the contact" do
      expect {
        delete "/api/v1/contacts/#{contact.id}", headers: headers
      }.to change(Contact, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/contacts/:id/deals" do
    let(:contact) { create(:contact) }
    before { create_list(:deal, 3, contact: contact, owner: user) }

    it "returns deals for the contact" do
      get "/api/v1/contacts/#{contact.id}/deals", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:deals].length).to eq(3)
    end
  end
end
