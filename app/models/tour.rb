class Tour < ApplicationRecord
  has_many :user_tours, dependent: :delete_all
  has_many :users, through: :user_tours
  has_many :tour_locations, dependent: :delete_all
  accepts_nested_attributes_for :tour_locations, allow_destroy: true

  enum status: {
      in_future: "In Future",
      completed: "Completed",
      cancelled: "Cancelled"
  }

  after_update do
    if status.to_s.eql? "cancelled"
      #users.where.not(role: "admin").destroy_all
      test = user_tours.where.not(:users => {:roll => 'agent'})
      puts test
    end
  end

end
