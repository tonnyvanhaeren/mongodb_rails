class ApplicationController < ActionController::API
  rescue_from Mongo::Error::NoServerAvailable, with: :mongodb_server_offline
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error  

  before_action :make_action_mailer_use_request_host_and_protocol


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

  ## helper methode for getting the absolute path
  ## absolute_url_for(action: 'confirm_email', controller: 'auth', token: user.email_confirm_token)
    
  def absolute_url_for(options = {})
    url_for(options.merge(Rails.configuration.x.absolute_url_options || {}))
  end
  
  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
