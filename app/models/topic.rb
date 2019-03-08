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

  include PgSearch
  pg_search_scope :topics_search,
    against: [ :title, :subcode ],
    associated_against: {
       category: [ :subject, :code ]
       # updates: [:topic_status]
       # user: [:first_name, :last_name]
    },
    using: {
      tsearch: { prefix: true }
    }
end
