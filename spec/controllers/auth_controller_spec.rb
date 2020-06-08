require 'rails_helper'

describe AuthController do
  describe '#confirm_email' do
    after { User.delete_all } ### clean database  

    let(:user) { create :user }

    it 'should return 200 status code when email verification is ok' do
      get :confirm_email, params: { token: user.email_confirm_token }
      expect(response).to have_http_status(:ok)

      found_user = User.find_by(email: user.email)

      ### get the user out the database and check 
      expect(found_user.is_email_verified).to be_truthy
      expect(found_user.email_confirm_token).to be_nil

      expect(json_data['attributes']).to eq({
        "email" => found_user.email,
        "first-name" => found_user.firstName,
        "last-name" => found_user.lastName,
        "is-accepted" => found_user.is_accepted,
        "full-name" => "antonius - vanhaeren",
        "is-email-verified" => found_user.is_email_verified,
        "created-at" => found_user.created_at.to_i,
        "updated-at" => found_user.updated_at.to_i
      })
    end

    it 'should return 400 status code when email verification failed' do
      get :confirm_email, params: { token: 'invalid_token' }
      expect(response).to have_http_status(:bad_request)
      expect(json['errors']).to include(
        {
          "code" =>   "400",
          "title" =>  "Email verification failed",
          "detail" => "Email verification token invalid"
        }
      )
    end
  end
end