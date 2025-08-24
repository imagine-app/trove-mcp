class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Existing relationships
  has_many :memberships, dependent: :destroy
  has_many :vaults, through: :memberships

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Compatibility method for existing code that uses `email`
  alias_attribute :email, :email_address
end
