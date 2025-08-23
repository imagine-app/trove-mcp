class CreateJoinTableContextsEntries < ActiveRecord::Migration[8.0]
  def change
    create_join_table :contexts, :entries, column_options: { type: :uuid } do |t|
      t.index [:context_id, :entry_id], unique: true
      t.index [:entry_id, :context_id]
    end
  end
end
