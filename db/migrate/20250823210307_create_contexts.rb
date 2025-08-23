class CreateContexts < ActiveRecord::Migration[8.0]
  def change
    create_table :contexts, id: :uuid do |t|
      t.references :vault, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :autotag, null: false

      t.timestamps
    end
  end
end
