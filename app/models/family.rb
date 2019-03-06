class Family < ApplicationRecord
  has_many :family_patients
  has_many :patients, through: :family_patients

  STATUS = ['active', 'inactive']

  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates :status, inclusion: { in: STATUS }
end
