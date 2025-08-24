class ChangeSessionsIdToUuid < ActiveRecord::Migration[8.0]
  def up
    # Drop the existing sessions table
    drop_table :sessions

    # Recreate with UUID as primary key
    create_table :sessions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :user_id, null: false
      t.string :ip_address
      t.string :user_agent
      t.timestamps

      t.index :user_id
    end

    add_foreign_key :sessions, :users
  end

  def down
    drop_table :sessions

    create_table :sessions do |t|
      t.uuid :user_id, null: false
      t.string :ip_address
      t.string :user_agent
      t.timestamps

      t.index :user_id
    end

    add_foreign_key :sessions, :users
  end
end
