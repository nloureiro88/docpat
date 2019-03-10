class DoctorPatient < ApplicationRecord
  belongs_to :patient, class_name: 'User'
  belongs_to :doctor, class_name: 'User'

  STATUS = ['created', 'active', 'inactive']

  validates :doctor_id, presence: true, allow_blank: false
  validates :patient_id, presence: true, allow_blank: false
  validates :patient_id, uniqueness: { scope: :doctor_id }
  validates_inclusion_of :praise, in: [true, false]
  validates :status, inclusion: { in: STATUS }
end
