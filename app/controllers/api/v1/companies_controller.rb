module Api
  module V1
    class CompaniesController < ApplicationController

      # GET /api/v1/companies
      def index
        companies = Company.search(params[:q])
                           .order(name: :asc)
                           .page(params[:page]).per(params[:per_page] || 20)

        json_response({ companies: companies.map { |c| serialize(c) }, meta: pagination_meta(companies) })
      end

      # GET /api/v1/companies/:id
      def show
        json_response({ company: serialize_full(find_company) })
      end

      # POST /api/v1/companies
      def create
        company = Company.create!(company_params)
        json_response({ message: "Company created", company: serialize(company) }, :created)
      end

      # PUT /api/v1/companies/:id
      def update
        company = find_company
        company.update!(company_params)
        json_response({ message: "Company updated", company: serialize(company) })
      end

      # DELETE /api/v1/companies/:id
      def destroy
        find_company.destroy!
        json_response({ message: "Company deleted successfully" })
      end

      # GET /api/v1/companies/:id/contacts
      def contacts
        company = find_company
        json_response({ contacts: company.contacts.map { |c| { id: c.id, full_name: c.full_name, email: c.email, job_title: c.job_title } } })
      end

      # GET /api/v1/companies/:id/deals
      def deals
        company = find_company
        json_response({ deals: company.deals.map { |d| { id: d.id, title: d.title, stage: d.stage, value: d.value } } })
      end

      private

      def find_company
        Company.find(params[:id])
      end

      def company_params
        params.permit(:name, :industry, :website, :phone, :address, :city, :country, :size, :notes)
      end

      def serialize(c)
        {
          id: c.id, name: c.name, industry: c.industry, website: c.website,
          phone: c.phone, address: c.address, city: c.city, country: c.country,
          size: c.size, notes: c.notes,
          contacts_count: c.contacts.count, deals_count: c.deals.count,
          created_at: c.created_at
        }
      end

      def serialize_full(c)
        serialize(c)
      end
    end
  end
end
