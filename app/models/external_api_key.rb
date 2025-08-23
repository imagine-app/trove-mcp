class ExternalApiKey < ApplicationRecord
  belongs_to :vault

  validates :name, presence: true
  validates :service_key, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }
end