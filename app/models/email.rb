class Email < ApplicationRecord
  include Entriable

  belongs_to :mailbox

  validates :to, presence: true
  validates :from, presence: true
  validates :body, presence: true
end
