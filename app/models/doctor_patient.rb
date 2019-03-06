class DoctorPatient < ApplicationRecord
  belongs_to :patient, class_name: 'User'
  belongs_to :doctor, class_name: 'User'

  STATUS = ['created', 'active', 'inactive']

  validates :doctor_id, presence: true, allow_blank: false
  validates :patient_id, presence: true, allow_blank: false
  validates :patient_id, uniqueness: { scope: :doctor_id }
  validates_inclusion_of :pr_skill, in: [true, false]
  validates_inclusion_of :pr_time, in: [true, false]
  validates_inclusion_of :pr_help, in: [true, false]
  validates_inclusion_of :pr_kind, in: [true, false]
  validates :status, inclusion: { in: STATUS }
end
