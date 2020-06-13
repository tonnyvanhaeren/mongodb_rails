require "rails_helper"

RSpec.describe UserAuthMailer, type: :mailer do
  describe "send_signup_email" do
    after { User.delete_all }

    let(:user) { create :user, email: 'antonius.vanhaeren@telenet.be' }
    let(:mail) { UserAuthMailer.with(user: user).send_signup_email.deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Verify email confirmation request")
      expect(mail.to).to eq(["antonius.vanhaeren@telenet.be"])
      expect(mail.from).to eq(["tonny.development@telenet.be"])
    end

    it 'should have access to URL helpers' do
      expect { auth_confirm_email_path_url(user.email_confirm_token) }.not_to raise_error
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thank you to sign up")

      # styles not included 
      # <form class="button_to" method="post"
      #     action="http://localhost:4000/auth/confirm_email/9vdNKsNS32hp9oMzJ50PIw">
      #     type="submit" value="Confirm your email"
      #   />
      # </form>

      expect(mail.body.encoded).to match(href=auth_confirm_email_path_url(user.email_confirm_token))
    end


  end
end