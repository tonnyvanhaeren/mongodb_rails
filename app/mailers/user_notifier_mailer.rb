class UserNotifierMailer < ApplicationMailer
  default :from => 'tonny.development@telenet.be'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email
    @user = params[:user]

    mail( :to => 'antonius.vanhaeren@telenet.be',
      :subject => 'Thanks for signing up' )
  end
end