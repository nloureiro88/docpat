class CreateFamilyPatients < ActiveRecord::Migration[5.2]
  def change
    create_table :family_patients do |t|
      t.references :family, index: true
      t.references :patient, index: true
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
