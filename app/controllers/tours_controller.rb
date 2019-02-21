class ToursController < ApplicationController
  before_action :set_tour, only: [:edit, :update, :destroy, :bookmark, :undo_bookmark, :book, :update_booking]
  before_action :require_login
  load_and_authorize_resource

  # GET /tours
  # GET /tours.json
  def index
    personalize = params[:my_tours]
    bookmarked_tours = params[:bookmarked_tours]
    waitlisted_tours = params[:waitlisted_tours]

    if personalize
      if current_user.role.eql? 'agent'
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
      @tour = Tour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:id, :name, :description, :created_at, :updated_at, :price, :booking_deadline, :from_date, :to_date, :total_seats, :op_email, :op_phone, :status, :my_tours,
                                   tour_locations_attributes: [:id, :country, :state_or_province, :_destroy])
    end
end
