require "rails_helper"

RSpec.describe "Dashboard API", type: :request do
  let(:user)    { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/dashboard/stats" do
    before do
      create_list(:contact, 3)
      create_list(:company, 2)
      create(:deal, :won,        owner: user, value: 100_000)
      create(:deal, :lost,       owner: user, value: 50_000)
      create(:deal, :in_proposal, owner: user, value: 75_000)
      create(:activity, :call,   user: user)
    end

    it "returns all dashboard sections" do
      get "/api/v1/dashboard/stats", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json).to have_key(:overview)
      expect(json).to have_key(:pipeline)
      expect(json).to have_key(:recent_activities)
      expect(json).to have_key(:top_open_deals)
      expect(json).to have_key(:monthly_revenue)
    end

    it "overview has correct counts" do
      get "/api/v1/dashboard/stats", headers: headers

      overview = json[:overview]
      expect(overview[:total_contacts]).to eq(3)
      expect(overview[:total_companies]).to eq(2)
      expect(overview[:won_deals]).to eq(1)
      expect(overview[:lost_deals]).to eq(1)
      expect(overview[:open_deals]).to eq(1)
      expect(overview[:total_revenue]).to eq(100_000.0)
    end

    it "pipeline contains all 6 stages" do
      get "/api/v1/dashboard/stats", headers: headers

      stages = json[:pipeline].map { |p| p[:stage] }
      expect(stages).to include("prospecting", "qualification", "proposal",
                                "negotiation", "closed_won", "closed_lost")
    end

    it "monthly_revenue returns 7 months" do
      get "/api/v1/dashboard/stats", headers: headers
      expect(json[:monthly_revenue].length).to eq(7)
    end
  end
end
