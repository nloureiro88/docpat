class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :photo, PhotoUploader

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

  STATUS = ['active', 'inactive']

  validates :first_name, presence: true, allow_blank: false
  validates :last_name, presence: true, allow_blank: false
  validates :gender, inclusion: { in: ['male', 'female', 'undefined'] }
  validates :photo, presence: true, allow_blank: false
  validates :address, presence: true, allow_blank: false
  validates :date_birth, presence: true, allow_blank: false
  validates :identity_card, presence: true, allow_blank: false
  validates :user_type, inclusion: { in: ['patient', 'doctor'] }
  validate :val_doc_info

  include PgSearch
  pg_search_scope :doctor_search,
    against: [:first_name, :last_name, :doc_specialties, :doc_institutions, :address],
    using: {
      tsearch: { prefix: true }
    }

  def val_doc_info
    return unless user_type == "doctor"

    if doc_number.nil?
      errors.add("Doctor professional number must be provided")
    elsif doc_specialties.size < 1
      errors.add("At least 1 medical specialty must be provided")
    end
  end
end
