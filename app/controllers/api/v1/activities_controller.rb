module Api
  module V1
    class ActivitiesController < ApplicationController

      # GET /api/v1/activities
      def index
        activities = Activity.includes(:contact, :deal, :user)
                             .filter_type(params[:activity_type])
                             .filter_contact(params[:contact_id])
                             .filter_deal(params[:deal_id])
                             .order(created_at: :desc)
                             .page(params[:page]).per(params[:per_page] || 30)

        json_response({ activities: activities.map { |a| serialize(a) }, meta: pagination_meta(activities) })
      end

      # GET /api/v1/activities/:id
      def show
        json_response({ activity: serialize(find_activity) })
      end

      # POST /api/v1/activities
      def create
        activity = Activity.create!(activity_params.merge(user_id: current_user.id))
        json_response({ message: "Activity logged", activity: serialize(activity) }, :created)
      end

      # PUT /api/v1/activities/:id
      def update
        activity = find_activity
        activity.update!(activity_params)
        json_response({ message: "Activity updated", activity: serialize(activity) })
      end

      # DELETE /api/v1/activities/:id
      def destroy
        find_activity.destroy!
        json_response({ message: "Activity deleted successfully" })
      end

      private

      def find_activity
        Activity.find(params[:id])
      end

      def activity_params
        params.permit(:activity_type, :subject, :description, :contact_id, :deal_id, :scheduled_at, :completed)
      end

      def serialize(a)
        {
          id: a.id, activity_type: a.activity_type, subject: a.subject,
          description: a.description, completed: a.completed, scheduled_at: a.scheduled_at,
          contact: a.contact ? { id: a.contact.id, name: a.contact.full_name } : nil,
          deal:    a.deal    ? { id: a.deal.id,    title: a.deal.title }        : nil,
          logged_by: a.user  ? { id: a.user.id,    name: a.user.name }          : nil,
          created_at: a.created_at
        }
      end
    end
  end
end
