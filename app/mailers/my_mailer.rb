class MyMailer < ActionMailer::Base
  require 'sendgrid-ruby'
  include SendGrid

  ## default from: 'notifications@example.com'

  def welcome_email
    # @user = params[:user]
    # @url  = 'http://example.com/login'
    # mail(to: @user.email, subject: 'Welcome to My Awesome Site')

    from = Email.new(email: 'tonny.development@telenet.be')
    to = Email.new(email: 'antonius.vanhaeren@telenet.be')
    subject = 'Sending with SendGrid is Fun'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = Mail.new(from, subject, to, content)

    ##Rails.application.credentials.mail[:sendgrid_api_key]
    ## sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    
    sg = SendGrid::API.new(api_key: Rails.application.credentials.mail[:sendgrid_api_key] )
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

end