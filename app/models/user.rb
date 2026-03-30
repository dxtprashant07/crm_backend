class User < ApplicationRecord
  has_secure_password

  has_many :owned_deals,  class_name: "Deal",     foreign_key: :owner_id, dependent: :nullify
  has_many :activities,                                                     dependent: :nullify

  enum role: { agent: 0, manager: 1, admin: 2 }, _default: :agent

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role,  inclusion: { in: roles.keys }

  before_save { self.email = email.downcase }

  scope :active, -> { where(active: true) }
end
