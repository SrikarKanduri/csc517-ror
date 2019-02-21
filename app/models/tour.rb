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

  def self.seats_booked(tour_id)
    UserTour.where({tour_id: tour_id, booked: 1}).sum(:num_booked)
  end

  def self.handle_show(tour_id, user_id)
    tour = Tour.find(tour_id)
    seats_available = tour.total_seats - self.seats_booked(tour_id)
    user_tour = UserTour.get_user_tour(tour_id, user_id)

    {:tour => tour, :seats_available => seats_available, :user_tour => user_tour}
  end

  def add_bookmark(current_user)
    users << current_user unless users.include? current_user
    user_tour = UserTour.get_user_tour(id, current_user.id)
    user_tour[:bookmarked] = true
    user_tour.save
  end

  def remove_bookmark(current_user)
    user_tour = UserTour.get_user_tour(id, current_user.id)
    user_tour[:bookmarked] = false
    user_tour.save
  end

  def book_tour(current_user, num_book_seats, num_waitlist_seats)
    users << current_user unless users.include? current_user
    seats_available = total_seats - Tour.seats_booked(id)
    user_tour = UserTour.get_user_tour(id, current_user.id)

    if seats_available.zero? && num_waitlist_seats > 0
      user_tour[:wait_listed] = true
      user_tour[:num_wait_listed] = num_waitlist_seats
    elsif num_book_seats <= seats_available
      user_tour[:booked] = true
      user_tour[:num_booked] = num_book_seats
    elsif num_waitlist_seats.zero?
      user_tour[:booked] = true
      user_tour[:num_booked] = seats_available
    elsif num_waitlist_seats.equal? num_book_seats
      user_tour[:wait_listed] = true
      user_tour[:num_wait_listed] = num_book_seats
    else
      user_tour[:booked] = true
      user_tour[:wait_listed] = true
      user_tour[:num_booked] = seats_available
      user_tour[:num_wait_listed] = num_waitlist_seats
    end

    user_tour.save
  end

end
