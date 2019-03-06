class Topic < ApplicationRecord
  belongs_to :patient, class_name: 'User'
  belongs_to :category

  has_many :updates
  has_many :documents
  has_many :schedules

  STATUS = ["active", "inactive"]

  validates :patient_id, presence: true, allow_blank: false
  validates :category_id, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false, uniqueness: { scope: :patient_id }
  validates :status, inclusion: { in: STATUS }
end
