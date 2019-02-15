class Tour < ApplicationRecord
  has_many :user_tours
  has_many :users, through: :user_tours
  has_many :tour_locations
end
