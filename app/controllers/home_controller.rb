class HomeController < ApplicationController
  before_action :set_role
  before_action :require_login

  def index
    session[:do_not_redirect] = true
  end

  private

  def set_role
    @role = current_user.role
    @greeting = "Here you can manage tasks as part of your role (" + @role + ")"
  end
end
