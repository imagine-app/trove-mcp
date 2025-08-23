class CreateExternalApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :external_api_keys, id: :uuid do |t|
      t.references :vault, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :service_key, null: false
      t.timestamp :expires_at, null: false

      t.timestamps
    end

    add_index :external_api_keys, :service_key, unique: true
  end
end
