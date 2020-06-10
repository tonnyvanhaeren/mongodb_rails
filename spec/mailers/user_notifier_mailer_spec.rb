require "rails_helper"

RSpec.describe UserNotifierMailer, type: :mailer do
  describe "send_signup_email" do
    let(:user) { build :user, email: 'antonius.vanhaeren@telenet.be' }
    let(:mail) { UserNotifierMailer.send_signup_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Thanks for signing up")
      expect(mail.to).to eq(["antonius.vanhaeren@telenet.be"])
      expect(mail.from).to eq(["tonny.development@telenet.be"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thanks for signing up")
    end
  end
end