# Preview all emails at http://localhost:3000/rails/mailers/user_auth_mailer
class UserAuthMailerPreview < ActionMailer::Preview

  def send_signup_email
    UserAuthMailer.with(user: User.last).send_signup_email 
  end
end
