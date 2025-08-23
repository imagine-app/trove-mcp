class Mailbox < ApplicationRecord
  belongs_to :vault
  has_many :emails, dependent: :destroy
end