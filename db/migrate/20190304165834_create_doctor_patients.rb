class CreateDoctorPatients < ActiveRecord::Migration[5.2]
  def change
    create_table :doctor_patients do |t|
      t.references :doctor, index: true
      t.references :patient, index: true
      t.boolean :pr_skill, default: false
      t.boolean :pr_time, default: false
      t.boolean :pr_help, default: false
      t.boolean :pr_kind, default: false
      t.float :pr_calc, default: 0
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
