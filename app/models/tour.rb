class Tour < ApplicationRecord
  has_many :user_tours
  has_many :users, through: :user_tours
  has_many :tour_locations
  accepts_nested_attributes_for :tour_locations, allow_destroy: true,
                                reject_if: lambda {|attr| attr['country'].blank? || attr['state_or_province'].blank?}

  enum status: {
      in_future: "In Future",
      completed: "Completed",
      cancelled: "Cancelled"
  }
end
