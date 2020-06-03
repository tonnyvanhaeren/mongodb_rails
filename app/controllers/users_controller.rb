class UsersController < ApplicationController
  ## skip_before_action :authorize!, only: :create

  def index
    users = User.all
    ### render json: users
    render json: users, status: :ok
  end

  def create
    
  end

end
