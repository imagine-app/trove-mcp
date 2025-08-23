class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :vault

  enum :role, { reader: 0, manager: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :vault_id }
end