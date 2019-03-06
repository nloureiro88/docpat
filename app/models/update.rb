class Update < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  delegate :patient, to: :topic, allow_nil: true

  HEALTH_STATUS = ["diagnosed", "under treatment", "cured", "inactive"]

  validates :topic_id, presence: true, allow_blank: false
  validates :user_id, presence: true, allow_blank: false
  validates :diagnosis, presence: true, allow_blank: false
  validates :topic_status, inclusion: { in: HEALTH_STATUS }
end
