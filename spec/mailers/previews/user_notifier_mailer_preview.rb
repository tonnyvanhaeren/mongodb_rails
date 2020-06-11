# Preview all emails at http://localhost:3000/rails/mailers/user_notifier_mailer
class UserNotifierMailerPreview < ActionMailer::Preview
  ## require "rails_helper"

  def send_signup_email
    UserNotifierMailer.with(user: User.last).send_signup_email 
  end
end
