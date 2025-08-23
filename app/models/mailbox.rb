class Mailbox < ApplicationRecord
  belongs_to :vault
  has_many :emails, class_name: "Entry::Email", dependent: :destroy
end
