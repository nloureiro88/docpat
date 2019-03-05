class CreateUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :updates do |t|
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.text :diagnosis
      t.string :next_steps, array: true, default: []
      t.string :topic_status, default: 'active'

      t.timestamps
    end
  end
end
