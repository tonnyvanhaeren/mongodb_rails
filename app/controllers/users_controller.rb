class UsersController < ApplicationController
  ## skip_before_action :authorize!, only: :create
  ## only admin user access

  def index
    page = params[:page]
    per_page = params[:per_page]

    users = User.all
      .skip(page ||= 0)
      .limit(per_page)
      .order_by(lastName: :asc)

    render json: users, status: :ok
  end

  def show
    user = User.find(params[:id])
    
    render json: user
    # rescue Mongoid::Errors::DocumentNotFound in application controller
    # rescue Mongoid::Errors::DocumentNotFound => e
    # not_found_error    
  end
end
