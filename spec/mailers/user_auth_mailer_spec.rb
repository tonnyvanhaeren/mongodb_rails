require "rails_helper"

RSpec.describe UserAuthMailer, type: :mailer do
  describe "send_signup_email" do
    after { User.delete_all }

    let(:user) { create :user, email: 'antonius.vanhaeren@telenet.be' }
    let(:mail) { UserAuthMailer.with(user: user).send_signup_email.deliver_now }

    context 'mail headers' do
      it "renders subject" do
        expect(mail.subject).to eq("Verify email confirmation request")
      end
      it "renders mail to" do
        expect(mail.to).to eq(["antonius.vanhaeren@telenet.be"])
      end
      it "renders mail from" do
        expect(mail.from).to eq(["tonny.development@telenet.be"])
      end

    end

    context 'url link' do
      it 'should use URL helpers' do
        expect { auth_confirm_email_path_url(user.email_confirm_token) }.not_to raise_error
      end
      it 'should contain host protocol and port' do
        expect(auth_confirm_email_path_url(user.email_confirm_token)).to include(ENV['HOST'])
        expect(auth_confirm_email_path_url(user.email_confirm_token)).to include(ENV['PROTOCOL'])
        expect(auth_confirm_email_path_url(user.email_confirm_token)).to include(ENV['PORT'])
      end
    end

    context 'mail body includes' do
      it "title" do
        expect(mail.body.encoded).to match("Thank you to sign up")
      end

      it "url link to email confirmation path" do
        expect(mail.body.encoded).to match(href=auth_confirm_email_path_url(user.email_confirm_token))
      end
    end
  end
end