class Schedule < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  delegate :patient, to: :topic, allow_nil: true

  SCHEDULE_TYPES = ['Medicine', 'Treatment', 'Physical therapy', 'Radiation therapy', 'Respiratory therapy', 'Other']
  STATUS = ['active', 'inactive']

  validates :topic_id, presence: true, allow_blank: false
  validates :user_id, presence: true, allow_blank: false
  validates :sc_type, inclusion: { in: SCHEDULE_TYPES }
  validates :sc_title, presence: true, allow_blank: false, uniqueness: { scope: :topic_id }
  validates :date_start, presence: true, allow_blank: false
  validates :date_end, presence: true, allow_blank: false
  validates :status, inclusion: { in: STATUS }

  include PgSearch
    pg_search_scope :schedules_search,
      against: [:status, :sc_type, :date_start, :date_end, :created_at],
      associated_against: {
         #topic: [:subcode, :title],
         #user: [:first_name, :last_name, :doc_specialties]
      },
      using: {
        tsearch: { prefix: true }
      }


end
