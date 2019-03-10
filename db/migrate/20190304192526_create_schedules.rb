class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true
      t.string :sc_type
      t.string :sc_title
      t.string :schedule
      t.string :dosage
      t.text :notes
      t.date :date_start
      t.date :date_end, default: Date.new(9999,12,31)
      t.string :status, default: 'active'
      t.integer :read_by
      t.timestamp :read_at

      t.timestamps
    end
  end
end
