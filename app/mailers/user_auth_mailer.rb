class UserAuthMailer < ApplicationMailer
  layout 'mailer'

  default from: 'tonny.development@telenet.be'

  def send_signup_email
    @user = params[:user]
    @url  = auth_confirm_email_path_url(token: @user.email_confirm_token)
    
    mail(to: @user.email, subject: 'Verify email confirmation request')
  end
end
