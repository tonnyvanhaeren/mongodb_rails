require 'rails_helper'

describe AuthController do
  describe '#signup' do 
    subject { post :signup, params: params }  

    context 'with invalid params provided' do
      let(:params) do
        {
          data: {
            attributes: {
              email: nil,
              firstName: nil,
              lastName: nil,
              password: nil
            }
          }
        }
      end

      it 'should return 422 status code ' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not create a new user' do
        expect{ subject }.not_to change { User.count }
      end

      it 'should return error messages in response body' do
        subject
        expect(json['errors']).to include(
          {
            "source" => { "pointer" => "/data/attributes/email" },
            "detail" =>  "can't be blank"
          },
          {
            "source" => { "pointer" => "/data/attributes/first-name" },
            "detail" =>  "can't be blank"
          },
          {
            "source" => { "pointer" => "/data/attributes/last-name" },
            "detail" =>  "can't be blank"
          },                    
          {
            "source" => { "pointer" => "/data/attributes/password" },
            "detail" =>  "can't be blank"
          }
        )
      end
    end

    context 'with valid params provided' do
      after { User.delete_all } ### clean database
      let(:params) do
        {
          data: {
            attributes: {
              email: 'test@test.com',
              firstName: "Antonius",
              lastName: "Vanhaeren",
              password: "password"
            }
          }
        }
      end

      it 'should return 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end
      
      it 'should create a user' do
        ## Band.where(name: "Photek").exists?
        expect(User.where(email: 'test@test.com').exists?).to be_falsey

        expect{ subject }.to change { User.count }.by(1)
        expect(User.where(email: 'test@test.com').exists?).to be_truthy
      end

      it 'should send a email confirmation msg to the correct user email' do
        expect{ subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq([ params[:data][:attributes][:email] ])
      end
    end
  end

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
        "role" => "user",
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