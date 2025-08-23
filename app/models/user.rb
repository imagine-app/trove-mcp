class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :vaults, through: :memberships

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  normalizes :email, with: ->(email) { email.strip.downcase }
end
