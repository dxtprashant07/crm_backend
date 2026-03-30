module Api
  module V1
    class ContactsController < ApplicationController

      # GET /api/v1/contacts
      def index
        contacts = Contact.includes(:company)
                          .search(params[:q])
                          .filter_status(params[:status])
                          .order(created_at: :desc)
                          .page(params[:page]).per(params[:per_page] || 20)

        json_response({ contacts: contacts.map { |c| serialize(c) }, meta: pagination_meta(contacts) })
      end

      # GET /api/v1/contacts/:id
      def show
        json_response({ contact: serialize_full(find_contact) })
      end

      # POST /api/v1/contacts
      def create
        contact = Contact.create!(contact_params)
        json_response({ message: "Contact created", contact: serialize(contact) }, :created)
      end

      # PUT /api/v1/contacts/:id
      def update
        contact = find_contact
        contact.update!(contact_params)
        json_response({ message: "Contact updated", contact: serialize(contact) })
      end

      # DELETE /api/v1/contacts/:id
      def destroy
        find_contact.destroy!
        json_response({ message: "Contact deleted successfully" })
      end

      # GET /api/v1/contacts/:id/deals
      def deals
        contact = find_contact
        json_response({ deals: contact.deals.map { |d| deal_summary(d) } })
      end

      # GET /api/v1/contacts/:id/activities
      def activities
        contact = find_contact
        acts = contact.activities.order(created_at: :desc).limit(20)
        json_response({ activities: acts.map { |a| activity_summary(a) } })
      end

      private

      def find_contact
        Contact.find(params[:id])
      end

      def contact_params
        params.permit(:first_name, :last_name, :email, :phone, :job_title,
                      :company_id, :status, :source, :notes)
      end

      def serialize(c)
        {
          id: c.id, first_name: c.first_name, last_name: c.last_name,
          full_name: c.full_name, email: c.email, phone: c.phone,
          job_title: c.job_title, status: c.status, source: c.source,
          company: c.company ? { id: c.company.id, name: c.company.name } : nil,
          notes: c.notes,
          created_at: c.created_at
        }
      end

      def serialize_full(c)
        serialize(c).merge(notes: c.notes, deals_count: c.deals.count, activities_count: c.activities.count)
      end

      def deal_summary(d)
        { id: d.id, title: d.title, stage: d.stage, value: d.value }
      end

      def activity_summary(a)
        { id: a.id, activity_type: a.activity_type, subject: a.subject, created_at: a.created_at }
      end
    end
  end
end
