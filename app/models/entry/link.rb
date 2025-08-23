class Entry::Link < ApplicationRecord
  self.table_name = "links"
  include Entriable

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
