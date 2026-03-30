class Deal < ApplicationRecord
  belongs_to :contact, optional: true
  belongs_to :company, optional: true
  belongs_to :owner,   class_name: "User", foreign_key: :owner_id, optional: true
  has_many   :activities, dependent: :destroy

  STAGES = %w[prospecting qualification proposal negotiation closed_won closed_lost].freeze

  STAGE_PROBABILITY = {
    "prospecting"   => 10,
    "qualification" => 25,
    "proposal"      => 50,
    "negotiation"   => 75,
    "closed_won"    => 100,
    "closed_lost"   => 0
  }.freeze

  validates :title, presence: true
  validates :stage, inclusion: { in: STAGES }
  validates :value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :probability, numericality: { in: 0..100 }, allow_nil: true

  before_validation :set_defaults

  scope :filter_stage, ->(s)   { s.present? ? where(stage: s) : all }
  scope :filter_owner, ->(uid) { uid.present? ? where(owner_id: uid) : all }
  scope :open,  -> { where.not(stage: %w[closed_won closed_lost]) }
  scope :won,   -> { where(stage: "closed_won") }
  scope :lost,  -> { where(stage: "closed_lost") }

  private

  def set_defaults
    self.stage       ||= "prospecting"
    self.value       ||= 0
    self.probability ||= STAGE_PROBABILITY[self.stage] || 10
  end
end
