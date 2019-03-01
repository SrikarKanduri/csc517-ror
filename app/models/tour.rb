class Tour < ApplicationRecord
  has_many :user_tours, dependent: :delete_all
  has_many :users, through: :user_tours
  has_many :tour_locations, dependent: :delete_all
  accepts_nested_attributes_for :tour_locations, allow_destroy: true
  has_many_attached :images

  enum status: {
      in_future: "In Future",
      completed: "Completed",
      cancelled: "Cancelled"
  }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :booking_deadline, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :total_seats, presence: true
  validates :op_email, presence: true
  # Make sure a tour's status can't be Cancelled or In Future if it has already started
  validates :status,
            exclusion: {in: %w(cancelled in_future),
                        if: :from_date_passed?,
                        message: "cannot be changed to 'Cancelled' or 'In Future' if the Tour has already started"}

  scope :status, -> (status) { where status: status}
  scope :from_date, -> (from_date) { where from_date: from_date }
  scope :to_date, -> (to_date) { where to_date: to_date }
  scope :price, -> (price) { where price: price}

  def from_date_passed?
    return Date.today >= from_date if from_date.present?
    false
  end

  def booking_deadline_passed?
    return Date.today > booking_deadline if booking_deadline.present?
    false
  end

  after_update do
    # if a tour's status is updated to 'cancelled', then delete associated user_tours records through the 'users' attribute
    if status.to_s.eql? "cancelled"
      users.each do |user|
        users.delete(user) unless user.role.eql? 'agent'
      end
    end
  end

  def self.seats_booked(tour_id)
    UserTour.where({tour_id: tour_id, booked: 1}).sum(:num_booked)
  end

  def self.seats_waitlisted(tour_id)
    UserTour.where({tour_id: tour_id, wait_listed: 1}).sum(:num_wait_listed)
  end

  def self.handle_show(tour_id, user_id)
    tour = Tour.find(tour_id)
    seats_available = tour.total_seats - Tour.seats_booked(tour_id)
    seats_waitlisted = Tour.seats_waitlisted(tour_id)
    user_tour = UserTour.get_user_tour(tour_id, user_id)
    customers = tour.users

    {:tour => tour, :seats_available => seats_available, :user_tour => user_tour, :seats_waitlisted => seats_waitlisted, :customers => customers}
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
      user_tour[:waitlisted_at] = DateTime.current
    elsif num_book_seats <= seats_available
      user_tour[:booked] = true
      user_tour[:num_booked] = num_book_seats
    elsif num_waitlist_seats.zero?
      user_tour[:booked] = true
      user_tour[:num_booked] = seats_available
    elsif num_waitlist_seats.equal? num_book_seats
      user_tour[:wait_listed] = true
      user_tour[:num_wait_listed] = num_book_seats
      user_tour[:waitlisted_at] = DateTime.current
    else
      user_tour[:booked] = true
      user_tour[:wait_listed] = true
      user_tour[:num_booked] = seats_available
      user_tour[:num_wait_listed] = num_waitlist_seats
      user_tour[:waitlisted_at] = DateTime.current
    end

    user_tour.save
  end

  def update_booking(current_user, num_cancel_seats)

    user_tour = UserTour.get_user_tour(id, current_user.id)
    user_tour[:num_booked] = user_tour[:num_booked] - num_cancel_seats

    if user_tour[:num_booked].zero?
      user_tour[:booked] = false
      user_tour[:wait_listed] = false
      user_tour[:num_wait_listed] = 0
      users.delete(current_user) unless user_tour[:bookmarked]
    end
    user_tour.save

    waitlisted = Tour.seats_waitlisted(id)
    next_waitlisted_customer = users.joins(:user_tours).where({user_tours: {num_wait_listed: 1..num_cancel_seats}})
                                   .order("user_tours.waitlisted_at").first()
    if waitlisted > 0 && next_waitlisted_customer
      new_user_tour = UserTour.get_user_tour(id, next_waitlisted_customer.id)
      new_user_tour[:booked] = true
      new_user_tour[:num_booked] += new_user_tour[:num_wait_listed]
      new_user_tour[:num_wait_listed] = 0
      new_user_tour[:wait_listed] = false
      new_user_tour.save
    end
  end

end
