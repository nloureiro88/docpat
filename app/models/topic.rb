class Topic < ApplicationRecord
  belongs_to :patient, class_name: 'User'
  belongs_to :category

  has_many :updates
  has_many :documents
  has_many :schedules
end
