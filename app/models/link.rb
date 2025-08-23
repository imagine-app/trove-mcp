class Link < ApplicationRecord
  include Entriable

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
