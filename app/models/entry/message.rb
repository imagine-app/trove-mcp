class Entry::Message < ApplicationRecord
  self.table_name = "messages"
  include Entriable

  validates :text, presence: true
end
