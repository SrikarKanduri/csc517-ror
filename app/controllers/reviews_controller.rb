class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_reviews, only: [:index]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    if current_user.role != "agent"
      user_id = current_user.id
      user_tours = current_user.user_tours.select {|x| x.user_id == user_id}
      @completed_tours = user_tours.map { |ut| Tour.where(id: ut[:tour_id], status: "Completed")}
      @review = Review.new
    else
      redirect_to home_url, notice: "Agents cannot create reviews"
    end
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
    if current_user.role != "agent"
      @review = Review.new(review_params)
      respond_to do |format|
        if @review.save
          format.html { redirect_to @review, notice: 'Review was successfully created.' }
          format.json { render :show, status: :created, location: @review }
        else
          format.html { render :new }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to home_url, notice: "Agents cannot create reviews"
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
    if current_user.role != "agent"
      @review.destroy
      respond_to do |format|
        format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to home_url, notice: "Agents cannot modify reviews"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
      # @tours =
    end

    def set_reviews
      if params[:my_reviews] == "true"
        user_id = current_user.id
        @reviews = Review.where(user_id: user_id)
        @title_message = "My Reviews for Completed Tours"
      else
        @reviews = Review.all
        @title_message = "All Reviews Available in TMS"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:subject, :message, :my_reviews)
    end
end
