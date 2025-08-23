class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts, id: :uuid do |t|
      t.references :context, null: false, foreign_key: true, type: :uuid
      t.text :text, null: false

      t.timestamps
    end
  end
end
