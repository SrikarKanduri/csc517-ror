class UserTour < ApplicationRecord
  belongs_to :user
  belongs_to :tour

  # Retrieve the user_tour record for tour and user
  def self.get_user_tour(tour_id, user_id)
    UserTour.find_by('user_id': user_id, 'tour_id': tour_id)
  end

end
