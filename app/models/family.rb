class Family < ApplicationRecord
  has_many :family_patients
  has_many :patients, through: :family_patients
end
