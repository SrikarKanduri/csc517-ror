class UserTour < ApplicationRecord
  belongs_to :user
  belongs_to :tour

  def self.get_user_tour_info(tour_id, user_id)
    # Get the number of available seats for the tour
    seats_booked = UserTour.where({tour_id: tour_id, booked: 1}).sum(:num_booked)
    tour = Tour.find(tour_id)
    seats_available = tour.total_seats - seats_booked

    # Get the user_tour record for tour and user
    user_tour_rec = UserTour.find_by('user_id': user_id, 'tour_id': tour_id)

    {:seats_available => seats_available, :user_tour_rec => user_tour_rec}
  end

end
