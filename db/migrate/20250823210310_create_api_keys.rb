class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.references :vault, null: false, foreign_key: true, type: :uuid
      t.string :token, null: false
      t.timestamp :expires_at, null: false

      t.timestamps
    end
  end
end
