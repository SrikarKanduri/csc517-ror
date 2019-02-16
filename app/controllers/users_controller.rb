class UsersController < Clearance::UsersController

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.role == "admin"
      return
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
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
end
