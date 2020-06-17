require 'rails_helper'

# used JsonApiHelpers methode json_data
# json = JSON.parse(response.body)
# json_data = json['data']

##id returns BSON::ObjectId('5ed7f61c37c50e21ba11bf4d')

describe UsersController do
  describe '#index' do
    before(:context) do
      create :user, email: 'bob.andries@telenet.be', lastName: 'Andries'
      create :user, email: 'bob.bonapart@telenet.be', lastName: 'Bonapart'
      create :user, email: 'bob.covits@telenet.be', lastName: 'Covits'
    end

    after(:context) do
      User.delete_all 
    end ### clean database  
  
    subject { get :index, params: params }

    context 'without pagination params' do
      let(:params) { nil }

      it 'should return 200 status code ' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'should return proper json' do
        subject

        User.each_with_index do |user, index|
          expect(json_data[index]).to  eq({
            "id" => user.id.to_s, 
            "type" => "users",
            "attributes" => {
              "email" => user.email,
              "first-name" => user.firstName,
              "last-name" => user.lastName,
              "is-accepted" => user.is_accepted,
              "full-name" => "#{user.firstName} - #{user.lastName}",
              "is-email-verified" => user.is_email_verified,
              "role" => "user",
              "created-at" => user.created_at.to_i,
              "updated-at" => user.updated_at.to_i
            }
          })
        end
      end

      it 'should order by lastName' do
        subject

        expect(json_data.length).to eq 3
        expect(json_data.first['attributes']['last-name']).to eq('Andries')
        expect(json_data.last['attributes']['last-name']).to eq('Covits')
      end
    end

    context 'with pagination params' do
      let(:params) { { page: 2, per_page: 1 } }

      it 'should order by lastName && paginate users if pagination params are provided' do

        subject
        expect(json_data.length).to eq 1
        expect(json_data.first['attributes']['last-name']).to eq('Covits')
      end
    end
  end

  describe '#show' do
    ## clean database
    after(:context) do
      User.delete_all
    end

    let(:user) { create :user }
    subject { get :show, params: { id: id } }

    context 'with valid user id params' do
      let(:id) { user.id }

      it 'should return 200 status code' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to eq({
          "email" => user.email,
          "first-name" => user.firstName,
          "last-name" => user.lastName,
          "is-accepted" => user.is_accepted,
          "full-name" => "antonius - vanhaeren",
          "is-email-verified" => user.is_email_verified,
          "role" => "user",
          "created-at" => user.created_at.to_i,
          "updated-at" => user.updated_at.to_i
        })
      end
    end

    context 'with invalid user id params' do
      let(:id) { 'invalid' }

      it 'should return proper json error' do
        subject
        expect(json['errors']).to include(
          {
            "code" =>   "404",
            "title" =>  "document with id : invalid not found",
            "detail" => "document id is not correct => check it"
          }
        )
      end      
    end
  end
end