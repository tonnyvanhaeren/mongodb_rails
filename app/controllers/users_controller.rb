class UsersController < ApplicationController
  ## skip_before_action :authorize!, only: :create

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

    MyMailer.with(user: @user).welcome_email.deliver_later
    render json: user
    # rescue Mongoid::Errors::DocumentNotFound in application controller
    # rescue Mongoid::Errors::DocumentNotFound => e
    #   not_found_error    
  end

  def create
    user = User.new(registration_params)
    user.save!

    render json: user, status: :created
  rescue Mongoid::Errors::Validations
    render json: user, adapter: :json_api,
    serializer: ErrorSerializer,
    status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:data).require(:attributes).permit(:email, :firstName, :lastName, :password) || 
      ActionController::Parameters.new
  end

end
