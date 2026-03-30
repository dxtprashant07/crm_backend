module Api
  module V1
    class DashboardController < ApplicationController

      # GET /api/v1/dashboard/stats
      def stats
        json_response({
          overview:           overview,
          pipeline:           pipeline,
          recent_activities:  recent_activities,
          top_open_deals:     top_open_deals,
          monthly_revenue:    monthly_revenue
        })
      end

      private

      def overview
        {
          total_contacts:          Contact.count,
          total_companies:         Company.count,
          total_deals:             Deal.count,
          open_deals:              Deal.open.count,
          won_deals:               Deal.won.count,
          lost_deals:              Deal.lost.count,
          total_revenue:           Deal.won.sum(:value).to_f.round(2),
          new_contacts_this_month: Contact.where("created_at >= ?", 30.days.ago).count
        }
      end

      def pipeline
        %w[prospecting qualification proposal negotiation closed_won closed_lost].map do |stage|
          s = Deal.where(stage: stage)
          { stage: stage, label: stage.humanize, count: s.count, total_value: s.sum(:value).to_f.round(2) }
        end
      end

      def recent_activities
        Activity.includes(:contact, :user).order(created_at: :desc).limit(10).map do |a|
          { id: a.id, type: a.activity_type, subject: a.subject,
            contact: a.contact&.full_name, by: a.user&.name, at: a.created_at }
        end
      end

      def top_open_deals
        Deal.open.order(value: :desc).limit(5).map do |d|
          { id: d.id, title: d.title, value: d.value, stage: d.stage, contact: d.contact&.full_name }
        end
      end

      def monthly_revenue
        6.downto(0).map do |months_ago|
          month_start = months_ago.months.ago.beginning_of_month
          month_end   = months_ago.months.ago.end_of_month
          revenue = Deal.won.where(updated_at: month_start..month_end).sum(:value).to_f.round(2)
          { month: month_start.strftime("%b %Y"), revenue: revenue }
        end
      end
    end
  end
end
