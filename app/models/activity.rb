class Activity < ApplicationRecord
  belongs_to :user,    optional: true
  belongs_to :contact, optional: true
  belongs_to :deal,    optional: true

  TYPES = %w[call email meeting note task stage_change].freeze

  validates :activity_type, inclusion: { in: TYPES }
  validates :subject,       presence: true

  scope :filter_type,    ->(t)   { t.present? ? where(activity_type: t) : all }
  scope :filter_contact, ->(cid) { cid.present? ? where(contact_id: cid) : all }
  scope :filter_deal,    ->(did) { did.present? ? where(deal_id: did) : all }
  scope :completed,      ->      { where(completed: true) }
  scope :pending,        ->      { where(completed: false) }
end
