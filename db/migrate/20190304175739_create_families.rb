class CreateFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :families do |t|
      t.string :name
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
