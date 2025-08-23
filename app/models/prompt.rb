class Prompt < ApplicationRecord
  belongs_to :context

  validates :text, presence: true
end
