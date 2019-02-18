class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  load_and_authorize_resource

  # GET /tours
  # GET /tours.json
  def index
    personalize = params[:my_tours]
    bookmarked_tours = params[:bookmarked_tours]

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
    else
      @tours = Tour.all
      @page_title = "All Tours"
    end
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    # If a user_tours record exists for this tour and this user, send it to the show view
    @user_tour_rec = UserTour.find_by('user_id': current_user.id, 'tour_id': @tour.id)
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
    @tour = Tour.find(params[:tour_id])
    @tour.users << current_user unless @tour.users.include? current_user
    user_tour = UserTour.find_by('user_id': current_user.id, 'tour_id': @tour.id)
    user_tour[:bookmarked] = true
    user_tour.save
    respond_to do |format|
      format.html { redirect_to @tour, notice: 'Tour has been bookmarked.' }
    end
  end

  def undo_bookmark

  end

  def book

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
