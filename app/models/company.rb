class Company < ApplicationRecord
  has_many :contacts, dependent: :nullify
  has_many :deals,    dependent: :nullify

  enum size: { startup: 0, small: 1, medium: 2, large: 3, enterprise: 4 }, _default: :small

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :search, ->(q) {
    if q.present?
      col = connection.adapter_name.downcase.include?("postgres") ? "ILIKE" : "LIKE"
      where("name #{col} :q OR industry #{col} :q OR city #{col} :q", q: "%#{q}%")
    else
      all
    end
  }
end
