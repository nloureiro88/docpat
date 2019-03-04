class FamilyPatient < ApplicationRecord
  belongs_to :family
  belongs_to :patient, class_name: 'User'
end
