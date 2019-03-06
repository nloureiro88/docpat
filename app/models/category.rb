class Category < ApplicationRecord
  has_many :topics
  has_many :updates, through: :topics

  validates :code, presence: true, allow_blank: false
  validates :subject, presence: true, allow_blank: false
  validates :icon_url, presence: true, allow_blank: false
end
