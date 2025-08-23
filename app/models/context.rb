class Context < ApplicationRecord
  belongs_to :vault
  has_many :prompts, dependent: :destroy
  has_and_belongs_to_many :entries, join_table: :contexts_entries

  validates :name, presence: true
  validates :description, presence: true
  validates :autotag, inclusion: { in: [true, false] }
end