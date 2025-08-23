class Message < ApplicationRecord
  include Entriable

  validates :text, presence: true
end
