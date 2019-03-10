class CreateDoctorPatients < ActiveRecord::Migration[5.2]
  def change
    create_table :doctor_patients do |t|
      t.references :doctor, index: true
      t.references :patient, index: true
      t.boolean :praise, default: false
      t.string :status, default: 'created'

      t.timestamps
    end
  end
end
