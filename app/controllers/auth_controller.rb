class AuthController < ApplicationController
  ## skip_before_action :authorize!, only: :create

  def confirm_email
    token = params[:token]
    user = User.where(email_confirm_token: token).first

    if user
      user.email_confirmation_ok
      ## send mail ok
      render json: user, status: :ok
    elsif
      ### send email not ok
      error = {
        "code" =>   "400",
        "title" =>  "Email verification failed",
        "detail" => "Email verification token invalid"
      }

      render json: { "errors": [ error ] }, status: :bad_request   
    end
  end

  def signup
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