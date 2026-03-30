require "rails_helper"

RSpec.describe "Deals API", type: :request do
  let(:user)    { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/deals" do
    before { create_list(:deal, 4, owner: user) }

    it "returns deals and pipeline summary" do
      get "/api/v1/deals", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:deals].length).to eq(4)
      expect(json[:pipeline]).to be_an(Array)
      expect(json[:pipeline].map { |p| p[:stage] }).to include("prospecting", "closed_won")
    end

    it "filters by stage" do
      create(:deal, :won, owner: user)
      get "/api/v1/deals?stage=closed_won", headers: headers

      expect(response).to have_http_status(:ok)
      json[:deals].each { |d| expect(d[:stage]).to eq("closed_won") }
    end
  end

  describe "GET /api/v1/deals/:id" do
    let(:deal) { create(:deal, :with_contact, owner: user) }

    it "returns full deal details including activities" do
      get "/api/v1/deals/#{deal.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:deal][:id]).to eq(deal.id)
      expect(json[:deal]).to have_key(:activities)
    end
  end

  describe "POST /api/v1/deals" do
    let(:contact) { create(:contact) }
    let(:params) do
      {
        title: "Big Enterprise Deal",
        value: 500000,
        stage: "proposal",
        contact_id: contact.id,
        expected_close_date: 30.days.from_now
      }
    end

    it "creates a deal owned by current user" do
      expect {
        post "/api/v1/deals", params: params.to_json, headers: headers
      }.to change(Deal, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json[:deal][:title]).to eq("Big Enterprise Deal")
      expect(json[:deal][:owner][:id]).to eq(user.id)
    end

    it "returns 422 without a title" do
      post "/api/v1/deals", params: { value: 1000 }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/deals/:id/update_stage" do
    let(:deal) { create(:deal, stage: "prospecting", owner: user) }

    it "moves deal to a new valid stage" do
      patch "/api/v1/deals/#{deal.id}/update_stage",
            params: { stage: "proposal" }.to_json,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:deal][:stage]).to eq("proposal")
      expect(deal.activities.reload.last.subject).to include("proposal")
    end

    it "rejects an invalid stage" do
      patch "/api/v1/deals/#{deal.id}/update_stage",
            params: { stage: "flying" }.to_json,
            headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:valid_stages]).to be_present
    end
  end

  describe "DELETE /api/v1/deals/:id" do
    let!(:deal) { create(:deal, owner: user) }

    it "deletes the deal" do
      expect {
        delete "/api/v1/deals/#{deal.id}", headers: headers
      }.to change(Deal, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
