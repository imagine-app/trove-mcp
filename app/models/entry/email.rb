class Entry::Email < ApplicationRecord
  self.table_name = "emails"
  include Entriable

  belongs_to :mailbox

  validates :to, presence: true
  validates :from, presence: true
  validates :body, presence: true
end
