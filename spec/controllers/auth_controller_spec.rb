require 'rails_helper'

describe AuthController do
  describe '#signup' do 
    subject { post :signup, params: params }  

    context 'with invalid user params provided' do
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

      it 'must return 422 status code ' do
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

    context 'with valid user params provided' do
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

      it 'should send a confirmation email to the correct user' do
        expect{ subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(ActionMailer::Base.deliveries.last.to).to eq([ params[:data][:attributes][:email] ])
      end
    end
  end

  describe '#login' do
    let(:andries) { create :user, email: 'bob.andries@telenet.be', lastName: 'Andries', password: '1Telindus' }
    let(:bonapart) { create :user, email: 'bob.bonapart@telenet.be', lastName: 'Bonapart', password: '2Telindus' }

    after(:context) do
      User.delete_all 
    end ### clean database  

    subject { post :login, params: params }

    context 'with empty params' do
      after { User.delete_all } ### clean database

      let(:params) do
        {
          data: {
            attributes: {
              email: '',
              password: ''
            }
          }
        }
      end

      it 'return 401 unauthorized' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'return authentication_error in  json format' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json['errors']).to include(
          {
            "code" =>   "401",
            "title" =>  "Invalid login or password",
            "detail" => "You must provide valid credentials in order to exchange them for a token"
          }
        )
      end

    end

    context 'with unknow email' do
      after { User.delete_all } ### clean database

      let(:params) do
        {
          data: {
            attributes: {
              email: 'unknow.email@gmail.com',
              password: 'unknown'
            }
          }
        }
      end

      it 'return 404 not found' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'return authentication_error in  json format' do
        subject
        expect(response).to have_http_status(:not_found)
        expect(json['errors']).to include(
          {
            "code" =>   "404",
            "title" =>  "document with id : #{params[:id]} not found",
            "detail" => "document id is not correct => check it"
          }
        )
      end
    end

    context 'with known email but not verified' do
      after { User.delete_all } ### clean database

      let(:params) do
        {
          data: {
            attributes: {
              email: andries.email,
              password: andries.password
            }
          }
        }
      end

      it 'return 401 unauthorized' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'return email_confirmation_error in  json format' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json['errors']).to include(
          {
            "code" =>   "401",
            "title" =>  "email confirmation",
            "detail" => "your email is not verified"
          }
        )
      end
    end

    context 'with invalid password email verified' do
      after { User.delete_all } ### clean database

      let(:params) do
        {
          data: {
            attributes: {
              email: bonapart.email,
              password: 'invalid_password'
            }
          }
        }
      end

      it 'return 401 unauthorized' do
        # mock email verified
        bonapart.email_confirmation_ok

        subject
        expect(response).to have_http_status(401)
      end
    end

    context 'with valid credentials and email verified' do
      after { User.delete_all } ### clean database

      let(:params) do
        {
          data: {
            attributes: {
              email: bonapart.email,
              password: '2Telindus'
            }
          }
        }
      end

      it 'return 200 ok' do
        # mock email verified
        bonapart.email_confirmation_ok
        
        subject
        expect(response).to have_http_status(200)
      end

    end
  end

  describe '#confirm_email' do
    after(:context) { User.delete_all } ### clean database  

    let(:user) { create :user }
    let(:found_user) {User.find_by(email: user.email) }    
    subject { get :confirm_email, params: { token: token } }

    context 'with valid email confirmation token' do
      let(:token) { user.email_confirm_token }

      # it { is_expected.to have_http_status(200) } 
      it 'should return statuscode 200' do
        expect(response).to have_http_status(:ok), "must return status code 200"
      end

      it 'set user attribute is_email_verified to true' do
        subject
        expect(found_user.is_email_verified).to be_truthy  
      end

      it 'set user attribute email_confirmation_token to nil' do
        subject
        expect(found_user.email_confirm_token).to be_nil 
      end

      it 'must return the correct json_data' do
        subject
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
    end

    context 'with invalid email confirmation token' do
      let(:token) { 'invalidToken' }

      it 'must return 400 status code' do
        subject
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to include(
          {
            "code" =>   "400",
            "title" =>  "Email verification failed",
            "detail" => "Email verification token invalid"
          }
        )
      end

      it 'must return proper json error' do
        subject
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
end