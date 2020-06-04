class UsersController < ApplicationController
  ## skip_before_action :authorize!, only: :create

  def index
    page = params[:page]
    per_page = params[:per_page]

    users = User.all
      .skip(page ||= 0)
      .limit(per_page)
      .order_by(lastName: :asc)

    ### render json: users
    render json: users, status: :ok
  end

  def create
    
  end

end
