class UsersController < Clearance::UsersController
  before_action :require_login, except: [:new]

  # def index
  #   if current_user.role == "admin"
  #     @users = User.all
  #   else
  #     flash[:error] = "Access denied."
  #     redirect_to root_url
  #   end
  # end

  def new
    @user = User.new
    render template: "users/new"
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end


  # PATCH /users/1
  # PATCH /users/1.json
  def update
    @user = User.find(params[:id])
    puts user_params[:password]

    # for non admins, if password not set, then ignore it
    if user_params[:password] && user_params[:password].empty?
      temp_params = user_params.slice!(:email, :role, :first_name, :last_name)
    else
      temp_params = user_params
    end

    respond_to do |format|
      if @user.update_attributes(temp_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    # admin account cannot be deleted
    if @user.role == "admin" then return end

    if @user.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @user, notice: 'Failed to destroy User.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    role = user_params.delete(:role)
    first_name = user_params.delete(:first_name)
    last_name = user_params.delete(:last_name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.role = role
      user.first_name = first_name
      user.last_name = last_name
    end
  end

  def user_params
    params.require(:user).permit(:id, :email, :password, :role, :first_name, :last_name) || Hash.new
  end
end