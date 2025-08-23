class CreateEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :emails, id: :uuid do |t|
      t.references :mailbox, null: false, foreign_key: true, type: :uuid
      t.string :to, null: false
      t.string :cc
      t.string :from, null: false
      t.string :subject
      t.text :body, null: false
      t.timestamp :received_at

      t.timestamps
    end

    add_index :emails, [:mailbox_id, :received_at]
  end
end
