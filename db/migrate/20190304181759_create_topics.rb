class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.references :patient, index: true
      t.references :category, index: true
      t.string :title
      t.string :code
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
