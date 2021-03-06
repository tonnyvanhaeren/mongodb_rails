class AuthController < ApplicationController
  ## skip_before_action :authorize!, only: :create

  def signup
    user = User.new(registration_params)
    user.save!

    UserAuthMailer.with(user: user).send_signup_email.deliver_now

    ## UserMailer.with(user: user).weekly_summary.deliver_now
    ## pp absolute_url_for(action: 'confirm_email', controller: 'auth', token: user.email_confirm_token)
    render json: user, status: :created
  rescue Mongoid::Errors::Validations
    render json: user, adapter: :json_api,
    serializer: ErrorSerializer,
    status: :unprocessable_entity
  end

  def confirm_email
    token = params[:token]
    user = User.where(email_confirm_token: token).first

    if user
      user.email_confirmation_ok
      ## send mail ok
      ## TODO send confirmation received email
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

  def login
    email = params[:data][:attributes][:email]
    password = params[:data][:attributes][:password]

    raise AuthenticationError if (email.blank? || password.blank?) # check params
    user = User.find_by(email: email ) # check exists
    raise EmailConfirmationError if (!user.is_email_verified) # check email verification
    raise AuthenticationError unless user.authenticate(password) # check eq password
    
    jwt_token = JsonWebToken.encode(id: user._id, email: user.email, role: user.role )
    render json: { jwt_token: jwt_token }, status: :ok
  end

  private

  def registration_params
    params.require(:data).require(:attributes).permit(:email, :firstName, :lastName, :password) || 
      ActionController::Parameters.new
  end

end