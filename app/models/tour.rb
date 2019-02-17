class Tour < ApplicationRecord
  has_many :user_tours
  has_many :users, through: :user_tours
  has_many :tour_locations, dependent: :delete_all
  accepts_nested_attributes_for :tour_locations, allow_destroy: true

  enum status: {
      in_future: "In Future",
      completed: "Completed",
      cancelled: "Cancelled"
  }
end
