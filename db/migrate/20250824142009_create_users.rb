class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    # Users table already exists, just add the email_address column and update structure
    add_column :users, :email_address, :string, null: true

    # Migrate existing data
    execute "UPDATE users SET email_address = email"

    # Make email_address not null and add index
    change_column_null :users, :email_address, false
    add_index :users, :email_address, unique: true

    # Remove the old email column
    remove_column :users, :email
  end
end
