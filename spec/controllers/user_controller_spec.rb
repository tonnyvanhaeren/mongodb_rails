require 'rails_helper'

describe UsersController do
  describe '#index' do
    before { User.delete_all } ### clean database    
    subject { get :index }

    it 'should return 200 status code ' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      create_list :user, 2
      subject
      # use JsonApiHelpers methode json_data
      # json = JSON.parse(response.body)
      # json_data = json['data']

      User.each_with_index do |user, index|
        expect(json_data[index]).to  eq({
          "id" => user.id.to_s, ## returns BSON::ObjectId('5ed7f61c37c50e21ba11bf4d')
          "type" => "users",
          "attributes" => {
            "email" => user.email,
            "first-name" => user.firstName,
            "last-name" => user.lastName,
            "is-accepted" => user.is_accepted,
            "full-name" => "antonius - vanhaeren",
            "is-email-verified" => user.is_email_verified
          }
        })
      end
    end

    it 'should only return email verified users' do
      user_un_verified = create :user, is_email_verified: false
      user_verified = create :user, is_email_verified: true
      expect(User.email_verified.count).to be(1)

      user_verified = create :user, is_email_verified: true
      expect(User.email_verified.count).to be(2)
    end

    it 'should only return accepted users' do
      user_un_verified = create :user, is_accepted: false
      user_verified = create :user, is_accepted: true
      expect(User.accepted.count).to be(1)

      user_verified = create :user, is_accepted: true
      expect(User.accepted.count).to be(2)
    end
  end
end