module Entriable
  extend ActiveSupport::Concern

  included do
    has_one :entry, as: :entriable, touch: true, dependent: :destroy
  end
end
