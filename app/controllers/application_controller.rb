class ApplicationController < ActionController::API
  rescue_from Mongo::Error::NoServerAvailable, with: :mongodb_server_offline
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error  

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
      "title" =>  "user with id : #{params[:id]} not found",
      "detail" => "user id not correct check"
    }

    render json: { "errors": [ error ] }, status: :not_found
  end
end
