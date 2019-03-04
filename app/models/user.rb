class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :prel, foreign_key: 'patient_id', class_name: 'DoctorPatient'
  has_many :drel, foreign_key: 'doctor_id', class_name: 'DoctorPatient'

  has_many :doctors, through: :prel
  has_many :patients, through: :drel

  has_many :family_patients, foreign_key: 'patient_id', class_name: 'FamilyPatient'
  has_many :families, through: :family_patients

  has_many :topics, foreign_key: 'patient_id', class_name: 'Topic'
  has_many :updates, through: :topics
  has_many :documents, through: :topics
  has_many :schedules, through: :topics
end
