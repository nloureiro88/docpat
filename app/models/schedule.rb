class Schedule < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  delegate :patient, to: :topic, allow_nil: true
end
