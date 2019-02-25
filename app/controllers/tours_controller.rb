class ToursController < ApplicationController
  before_action :set_tour, only: [:edit, :update, :destroy, :bookmark, :undo_bookmark, :book, :update_booking]
  before_action :require_login
  load_and_authorize_resource
  # before_action :check_review_options, only: [:show]

  # GET /show_search
  def show_search
    @tour = Tour.new
    @tour.tour_locations.build
  end

  def search
    # creating model. Raw params are ugly to use
    tour = Tour.new(tour_params)
    return [find_tours_from_search(tour), tour]
  end

  # GET /tours
  # GET /tours.json
  def index
    if params[:search]
      @page_title = "List of Tours from filter"
      # function located above...
      search_results = search()
      @tours = search_results[0]
      @filter = search_results[1]
    else
      personalize = params[:my_tours]
      bookmarked_tours = params[:bookmarked_tours]
      waitlisted_tours = params[:waitlisted_tours]

      if personalize
        if %w[admin agent].include?(current_user.role)
          @tours = current_user.tours
          @page_title = "My Tours"
        elsif current_user.role.eql? 'customer'
          booked_user_tours = current_user.user_tours.select {|x| x.booked?}
          @tours = booked_user_tours.map {|ut| Tour.find(ut[:tour_id])}
          @page_title = "My Booked Tours"
        end
      elsif bookmarked_tours
        bookmarked_user_tours = current_user.user_tours.select {|x| x.bookmarked?}
        @tours = bookmarked_user_tours.map {|ut| Tour.find(ut[:tour_id])}
        @page_title = "My Bookmarked Tours"
      elsif waitlisted_tours
        waitlisted_user_tours = current_user.user_tours.select {|x| x.wait_listed?}
        @tours = waitlisted_user_tours.map {|ut| Tour.find(ut[:tour_id])}
        @page_title = "My Waitlisted Tours"
      else
        @tours = Tour.all
        @page_title = "All Tours"
      end
    end
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    # Get tour information from the model so we use it in the show view
    hash = Tour.handle_show(params[:id], current_user.id)
    @tour = hash[:tour]
    @seats_available = hash[:seats_available]
    @seats_waitlisted = hash[:seats_waitlisted]
    @user_tour = hash[:user_tour]
  end

  # GET /tours/new
  def new
    @tour = Tour.new
    # create a new empty tour_locations instance so locations can be saved while creating a tour
    @tour.tour_locations.build
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        # Save the current user to the new tour's list of users... this creates the association record in the user_tours table
        @tour.users << current_user
        format.html { redirect_to @tour, notice: 'Tour was successfully created.' }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url, notice: 'Tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bookmark
    @tour.add_bookmark(current_user)
    respond_to do |format|
      format.html { redirect_to @tour, notice: 'Tour has been bookmarked.' }
    end
  end

  def undo_bookmark
    @tour.remove_bookmark(current_user)
    respond_to do |format|
      format.html { redirect_to @tour, notice: 'Bookmark removed!'}
    end
  end

  def book
    @tour.book_tour(current_user, params[:num_seats].to_i, params[:waitlist_amt].to_i)
    respond_to do |format|
      format.html { redirect_to @tour, notice: 'Booking complete!'}
    end
  end

  def update_booking
    @tour.update_booking(current_user, params[:cancel_seats].to_i)
    respond_to do |format|
      format.html { redirect_to @tour, notice: 'Booking updated!'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      tour = Tour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:id, :name, :description, :created_at, :updated_at, :price, :booking_deadline, :from_date, :to_date, :total_seats, :op_email, :op_phone, :status, :my_tours,
                                   tour_locations_attributes: [:id, :country, :state_or_province, :_destroy])
    end

    def search_params
      params[:tour].slice(:name, :price, :booking_deadline, :from_date, :to_date, :total_seats, :status,
                   tour_locations_attributes: [:country, :state_or_province])
    end

    def find_tours_from_search(tour)
      tours = Tour.where(nil)
      tours = tours.status(tour.status) if tour.status.present?
      # scope for name didn't work for me
      tours = Tour.where(name: tour.name) if tour.name.present?
      tours = tours.price(tour.price) if tour.price.present?
      tours = tours.booking_deadline(tour.booking_deadline) if tour.booking_deadline.present?
      tours = tours.from_date(tour.from_date) if tour.from_date.present?
      tours = tours.to_date(tour.to_date) if tour.to_date.present?
      tours = tours.total_seats(tour.total_seats) if tour.total_seats.present?

      # even if no itinerary provided, there's an element at index=0 which is empty
      if tour.tour_locations.length > 0 and !tour.tour_locations[0].country.empty?
        tour.tour_locations.each do |itinerary|
          tours = tours.itinerary(itinerary) if itinerary
        end
      end
      return tours
    end
end
