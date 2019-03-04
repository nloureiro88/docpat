class Category < ApplicationRecord
  has_many :topics
  has_many :updates, through: :topics
end
