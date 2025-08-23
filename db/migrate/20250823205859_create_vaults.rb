class CreateVaults < ActiveRecord::Migration[8.0]
  def change
    create_table :vaults, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
