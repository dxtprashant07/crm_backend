class Contact < ApplicationRecord
  belongs_to :company, optional: true
  has_many   :deals,      dependent: :nullify
  has_many   :activities, dependent: :destroy

  enum status: { lead: 0, prospect: 1, customer: 2, churned: 3 }, _default: :lead
  enum source: { website: 0, referral: 1, cold_outreach: 2, social_media: 3, event: 4, other: 5 }, _default: :other

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true,
                         uniqueness: { case_sensitive: false },
                         format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save { self.email = email.downcase }

  scope :search,         ->(q)      {
    if q.present?
      col = connection.adapter_name.downcase.include?("postgres") ? "ILIKE" : "LIKE"
      where("first_name #{col} :q OR last_name #{col} :q OR email #{col} :q", q: "%#{q}%")
    else
      all
    end
  }
  scope :filter_status,  ->(status) { status.present? ? where(status: status) : all }

  def full_name
    "#{first_name} #{last_name}"
  end
end
