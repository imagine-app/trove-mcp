class Vault < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :mailboxes, dependent: :destroy
  has_many :contexts, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :external_api_keys, dependent: :destroy
  has_many :api_keys, dependent: :destroy

  validates :name, presence: true
end
