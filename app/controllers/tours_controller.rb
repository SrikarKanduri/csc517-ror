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
    # if image(s) attached they will be found inside tour_params
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
      # if image(s) attached they will be found inside tour_params
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
    if params[:picture_id]
      delete_picture(params[:picture_id])
      respond_to do |format|
        format.html { redirect_to tour_url(@tour.id), notice: 'Image was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      @tour.destroy
      respond_to do |format|
        format.html { redirect_to tours_url, notice: 'Tour was successfully destroyed.' }
        format.json { head :no_content }
      end
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
      params.require(:tour).permit(:id, :name, :description, :created_at, :updated_at, :price, 
                                   :booking_deadline, :from_date, :to_date, :total_seats, 
                                   :op_email, :op_phone, :status, :my_tours,
                                   images: [],
                                   tour_locations_attributes: [:id, :country, :state_or_province, :_destroy])
    end

    def search_params
      params[:tour].slice(:name, :price, :booking_deadline, :from_date, :to_date, :total_seats, :status,
                   tour_locations_attributes: [:country, :state_or_province])
    end

    def find_tours_from_search(tour)
      query = Tour.joins(:tour_locations).distinct
      query = query.status(tour.status) if tour.status.present?
      query = query.where("name LIKE ?", "%#{tour.name}%") if tour.name.present?
      query = query.price(tour.price) if tour.price.present?
      query = query.from_date(tour.from_date) if tour.from_date.present?
      query = query.to_date(tour.to_date) if tour.to_date.present?
      query = query.where(tour_locations: {state_or_province: params[:tour]["tour_locations_attributes"]["0"]["state_or_province"]}) if params[:tour]["tour_locations_attributes"]["0"]["state_or_province"].present?
      query = query.where(tour_locations: {country: params[:tour]["tour_locations_attributes"]["1"]["country"]}) if params[:tour]["tour_locations_attributes"]["1"]["country"].present?

      return query.all
    end

    def delete_picture(picture_id)
      image = ActiveStorage::Attachment.find(picture_id)
      # Synchronously destroy the images and actual resource files.
      image.purge
    end
end
