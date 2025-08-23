class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links, id: :uuid do |t|
      t.string :url, null: false
      t.string :title

      t.timestamps
    end
  end
end
