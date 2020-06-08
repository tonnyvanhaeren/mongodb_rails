# config/initializers/smtp.rb
# ActionMailer::Base.smtp_settings = {
#   address: 'smtp.sendgrid.net',
#   port: 587,
#   domain: 'yourdomain.com',
#   user_name: ENV['SENDGRID_USERNAME'],
#   password: ENV['SENDGRID_PASSWORD'],
#   authentication: :login,
#   enable_starttls_auto: true
# }

{
  domain: 'localhost:3000',
  address: "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       Rails.application.credentials.mail[:sendgrid_api_key] ##ENV['SENDGRID_API_KEY']
}