class Update < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  delegate :patient, to: :topic, allow_nil: true

  HEALTH_STATUS = ["diagnosed", "under treatment", "cured", "inactive"]

  validates :topic_id, presence: true, allow_blank: false
  validates :user_id, presence: true, allow_blank: false
  validates :diagnosis, presence: true, allow_blank: false
  validates :topic_status, inclusion: { in: HEALTH_STATUS }

  include PgSearch
  pg_search_scope :updates_search,
    against: [:topic_status, :created_at],
    associated_against: {
       topic: [:subcode, :title],
       user: [:first_name, :last_name, :doc_specialties]
    },
    using: {
      tsearch: { prefix: true }
    }
end
