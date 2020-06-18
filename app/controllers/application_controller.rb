class ApplicationController < ActionController::API
  class AuthenticationError  < StandardError; end
  class EmailConfirmationError  < StandardError; end

  rescue_from Mongo::Error::NoServerAvailable, with: :mongodb_server_offline
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error  
  rescue_from AuthenticationError, with: :authentication_error
  rescue_from EmailConfirmationError, with: :email_confirmation_error
  
  def mongodb_server_offline
    error = {
      "code" =>   "503",
      "title" =>  "Service mobgodb (database) unavailable",
      "detail" => "please wait 5 min, if problem persists contact admin"
    }

    render json: { "errors": [ error ] }, status: :service_unavailable
  end

  def not_found_error
    error = {
      "code" =>   "404",
      "title" =>  "document with id : #{params[:id]} not found",
      "detail" => "document id is not correct => check it"
    }

    render json: { "errors": [ error ] }, status: :not_found
  end

  def authentication_error
    error = {
      "code" =>   "401",
      "title" =>  "Invalid login or password",
      "detail" => "You must provide valid credentials in order to exchange them for a token"
    }

    render json: { "errors": [ error ] }, status: 401
  end

  def email_confirmation_error
    error = {
      "code" =>   "401",
      "title" =>  "email confirmation",
      "detail" => "your email is not verified"
    }

    render json: { "errors": [ error ] }, status: 401
  end
end
