require "rails_helper"

RSpec.describe "Activities API", type: :request do
  let(:user)    { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/activities" do
    before { create_list(:activity, 5, user: user) }

    it "returns paginated activities" do
      get "/api/v1/activities", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:activities].length).to eq(5)
      expect(json[:meta]).to have_key(:total_count)
    end

    it "filters by activity_type" do
      create(:activity, :email, user: user)
      get "/api/v1/activities?activity_type=email", headers: headers

      expect(response).to have_http_status(:ok)
      json[:activities].each { |a| expect(a[:activity_type]).to eq("email") }
    end

    it "filters by contact_id" do
      contact = create(:contact)
      create(:activity, :with_contact, contact: contact, user: user)
      get "/api/v1/activities?contact_id=#{contact.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json[:activities].each { |a| expect(a[:contact][:id]).to eq(contact.id) }
    end

    it "filters by deal_id" do
      deal = create(:deal, owner: user)
      create(:activity, :with_deal, deal: deal, user: user)
      get "/api/v1/activities?deal_id=#{deal.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json[:activities].each { |a| expect(a[:deal][:id]).to eq(deal.id) }
    end

    it "returns 401 without auth" do
      get "/api/v1/activities"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/activities/:id" do
    let(:activity) { create(:activity, user: user) }

    it "returns activity details" do
      get "/api/v1/activities/#{activity.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:activity][:id]).to eq(activity.id)
      expect(json[:activity][:subject]).to eq(activity.subject)
    end

    it "returns 404 for unknown activity" do
      get "/api/v1/activities/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/activities" do
    let(:contact) { create(:contact) }
    let(:deal)    { create(:deal, owner: user) }

    let(:valid_params) do
      {
        activity_type: "call",
        subject:       "Discovery call with prospect",
        description:   "Discussed requirements and budget",
        contact_id:    contact.id,
        deal_id:       deal.id,
        completed:     false,
        scheduled_at:  1.day.from_now
      }
    end

    it "logs a new activity assigned to current user" do
      expect {
        post "/api/v1/activities", params: valid_params.to_json, headers: headers
      }.to change(Activity, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json[:activity][:activity_type]).to eq("call")
      expect(json[:activity][:logged_by][:id]).to eq(user.id)
    end

    it "rejects invalid activity_type" do
      post "/api/v1/activities",
           params: valid_params.merge(activity_type: "smoke_signal").to_json,
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "rejects missing subject" do
      post "/api/v1/activities",
           params: { activity_type: "call" }.to_json,
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /api/v1/activities/:id" do
    let(:activity) { create(:activity, user: user, completed: false) }

    it "marks activity as completed" do
      put "/api/v1/activities/#{activity.id}",
          params: { completed: true }.to_json,
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json[:activity][:completed]).to eq(true)
    end
  end

  describe "DELETE /api/v1/activities/:id" do
    let!(:activity) { create(:activity, user: user) }

    it "deletes the activity" do
      expect {
        delete "/api/v1/activities/#{activity.id}", headers: headers
      }.to change(Activity, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
