module Api
  module V1
    class DealsController < ApplicationController

      STAGES = %w[prospecting qualification proposal negotiation closed_won closed_lost].freeze

      # GET /api/v1/deals
      def index
        deals = Deal.includes(:contact, :company, :owner)
                    .filter_stage(params[:stage])
                    .filter_owner(params[:owner_id])
                    .order(created_at: :desc)
                    .page(params[:page]).per(params[:per_page] || 20)

        json_response({
          deals: deals.map { |d| serialize(d) },
          pipeline: pipeline_summary,
          meta: pagination_meta(deals)
        })
      end

      # GET /api/v1/deals/:id
      def show
        json_response({ deal: serialize_full(find_deal) })
      end

      # POST /api/v1/deals
      def create
        deal = Deal.create!(deal_params.merge(owner_id: current_user.id))
        json_response({ message: "Deal created", deal: serialize(deal) }, :created)
      end

      # PUT /api/v1/deals/:id
      def update
        deal = find_deal
        deal.update!(deal_params)
        json_response({ message: "Deal updated", deal: serialize(deal) })
      end

      # PATCH /api/v1/deals/:id/update_stage
      def update_stage
        deal = find_deal
        stage = params[:stage].to_s

        return json_response({ error: "Invalid stage", valid_stages: STAGES }, :unprocessable_entity) unless STAGES.include?(stage)

        deal.update!(stage: stage)
        deal.activities.create!(
          activity_type: "stage_change",
          subject:       "Stage updated to: #{stage.humanize}",
          user:          current_user
        )
        json_response({ message: "Stage updated to #{stage.humanize}", deal: serialize(deal) })
      end

      # DELETE /api/v1/deals/:id
      def destroy
        find_deal.destroy!
        json_response({ message: "Deal deleted successfully" })
      end

      private

      def find_deal
        Deal.find(params[:id])
      end

      def deal_params
        params.permit(:title, :value, :stage, :probability, :expected_close_date,
                      :contact_id, :company_id, :owner_id, :notes)
      end

      def serialize(d)
        {
          id: d.id, title: d.title, value: d.value, stage: d.stage,
          probability: d.probability, expected_close_date: d.expected_close_date,
          contact: d.contact ? { id: d.contact.id, name: d.contact.full_name } : nil,
          company: d.company ? { id: d.company.id, name: d.company.name } : nil,
          owner:   d.owner   ? { id: d.owner.id,   name: d.owner.name }   : nil,
          created_at: d.created_at
        }
      end

      def serialize_full(d)
        serialize(d).merge(
          notes: d.notes,
          activities: d.activities.order(created_at: :desc).limit(10).map { |a|
            { id: a.id, type: a.activity_type, subject: a.subject, at: a.created_at }
          }
        )
      end

      def pipeline_summary
        STAGES.map do |stage|
          subset = Deal.where(stage: stage)
          { stage: stage, count: subset.count, total_value: subset.sum(:value).to_f.round(2) }
        end
      end
    end
  end
end
