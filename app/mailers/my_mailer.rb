class MyMailer < ActionMailer::Base
  require 'sendgrid-ruby'
  include SendGrid
    default from: 'tonny.development@telenet.be'

  def welcome_email


    # @user = params[:user]
    # @url  = 'http://example.com/login'
    # mail(to: @user.email, subject: 'Welcome to My Awesome Site')

    # from = Email.new(email: 'tonny.development@telenet.be')
    # to = Email.new(email: 'antonius.vanhaeren@telenet.be')
    # subject = 'Sending with SendGrid is Fun'
    # content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    # mail = Mail.new(from, subject, to, content)

    # ##Rails.application.credentials.mail[:sendgrid_api_key]
    # ## sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    
    # sg = SendGrid::API.new(api_key: Rails.application.credentials.mail[:sendgrid_api_key] )
    # response = sg.client.mail._('send').post(request_body: mail.to_json)
    # puts response.status_code
    # puts response.body
    # puts response.headers
  end

  def sendgrid
    @user = params[:user]

    data = JSON.parse('{
      "personalizations": [
        {
          "to": [
            {
              "email": "antonius.vanhaeren.av@gmail.com",
              "name": "Antonius"
            }
          ],
          "dynamic_template_data": {
            "firstName": "Jef",
            "lastName": "Vanhaeren",
            "confirmation_url": "http://localhost:3000/auth/confirm_email/TOKEN"
          },
          "subject": "Hello, World!"
        }
      ],
      "from": {
        "email": "tonny.development@telenet.be",
        "name": "Tonny"
      },
      "template_id": "d-d41cdc8bacfb44d5be670eeed0ecf100"
    }')
    sg = SendGrid::API.new(api_key: Rails.application.credentials.mail[:sendgrid_api_key])
    response = sg.client.mail._("send").post(request_body: data)
    puts response.status_code
    puts response.body
    puts response.parsed_body
    puts response.headers
  end

end