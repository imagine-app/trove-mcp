class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :vault, null: false, foreign_key: true, type: :uuid
      t.integer :role, null: false

      t.timestamps
    end

    add_index :memberships, [:user_id, :vault_id], unique: true
  end
end
