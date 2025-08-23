class Entry < ApplicationRecord
  belongs_to :vault
  delegated_type :entriable, types: %w[Entry::Email Entry::Message Entry::Link]
  has_and_belongs_to_many :contexts, join_table: :contexts_entries

  has_many_attached :attachments

  validates :entriable, presence: true
end
