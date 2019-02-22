class ReviewsController < ApplicationController
  before_action :require_login
  before_action :check_tour, only: [:new, :create, :edit, :update]
  before_action :set_review, only: [:edit, :show, :update]
  before_action :set_reviews, only: [:index]
  before_action :handle_delete, only: [:destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new?tour_id=...
  # Requires tour_id and current_user
  # Requires an existing tour whose status is "completed"
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    if current_user.role != "agent"
    else
      redirect_to home_url, notice: "Agents cannot modify reviews"
    end
  end

  # POST /reviews
  # POST /reviews.json
  def create
    user_id = current_user.id
    # for some reason review_params.delete(:message) won't work...
    tour_id = params["tour_id"]
    message = review_params.delete(:message)
    subject = review_params.delete(:subject)

    @review = Review.new(review_params).tap do |review|
      review.user_id = user_id
      review.tour_id = tour_id
      review.message = message
      review.subject = subject
    end

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    if current_user.role != "agent"
      respond_to do |format|
        if @review.update(review_params)
          format.html { redirect_to @review, notice: 'Review was successfully updated.' }
          format.json { render :show, status: :ok, location: @review }
        else
          format.html { render :edit }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to home_url, notice: "Agents cannot modify reviews"
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_reviews
      if params[:my_reviews] == "true"
        if current_user.role == "agent"
          redirect_to home_url, notice: "Agents cannot create or modify reviews"
        end
        # this shows reviews#index view
        user_id = current_user.id
        @reviews = Review.where(user_id: user_id)
        @title_message = "My Reviews for Completed Tours"
      elsif params[:tour_id]
        tour_id = params[:tour_id]
        @reviews = Review.where(tour_id: tour_id)
        @title_message = "Reviews for Selected Tour"
      else
        @reviews = Review.all
        @title_message = "All Reviews Available in TMS"
      end
    end

    def check_tour
      user_id = current_user.id
      tour_id = params[:tour_id]
      tour = Tour.find_by(id: tour_id, status: "Completed")

      # check for disqualifying reasons...
      if current_user.role == "agent"
        redirect_to home_url, notice: "Agents cannot create reviews"
      elsif tour_id == nil
        redirect_to tours_url, notice: "No tour id found in url"
      elsif !UserTour.find_by(tour_id: tour_id, user_id: user_id)
        redirect_to tours_url, notice: "No tour found for the User"
      elsif !tour
        redirect_to tours_url, notice: "The selected Tour for User is not 'Completed'"
      else
        @completed_tour = tour
      end
    end

    def handle_delete
      user_id = current_user.id
      tour_id = params[:tour_id]
      review = Review.find(params[:id])

      if current_user.role == "agent"
        redirect_to tours_url, notice: "Agents cannot delete reviews"
      elsif !UserTour.find_by(user_id: user_id, tour_id: tour_id)
        redirect_to tours_url, notice: "Cannot delete tour. You did not book this tour."
      else
        @review = review
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:tour_id)
      params.require(:review).permit(:subject, :message, :my_reviews, :tour_id)
    end
end
