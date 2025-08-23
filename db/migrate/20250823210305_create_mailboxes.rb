class CreateMailboxes < ActiveRecord::Migration[8.0]
  def change
    create_table :mailboxes, id: :uuid do |t|
      t.references :vault, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
