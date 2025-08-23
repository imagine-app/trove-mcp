class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.text :text, null: false

      t.timestamps
    end
  end
end
