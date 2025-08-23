class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries, id: :uuid do |t|
      t.references :vault, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.references :entriable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end

    add_index :entries, [:vault_id, :entriable_type]
    add_index :entries, [:entriable_type, :entriable_id]
  end
end
