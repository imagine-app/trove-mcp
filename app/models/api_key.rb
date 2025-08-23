class ApiKey < ApplicationRecord
  belongs_to :vault

  validates :token, presence: true
  validates :expires_at, presence: true

  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }

  before_create :generate_token

  private

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end
end