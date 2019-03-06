class FamilyPatient < ApplicationRecord
  belongs_to :family
  belongs_to :patient, class_name: 'User'

  STATUS = ['created', 'active', 'inactive']

  validates :family_id, presence: true, allow_blank: false
  validates :patient_id, presence: true, allow_blank: false
  validates :patient_id, uniqueness: { scope: :family_id }
  validates :status, inclusion: { in: STATUS }
end
