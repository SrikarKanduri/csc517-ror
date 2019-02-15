class Tour < ApplicationRecord
  has_many :user_tours
  has_many :users, through: :user_tours
  has_many :tour_locations

  enum status: {
      in_future: "In Future",
      completed: "Completed",
      cancelled: "Cancelled"
  }
end
