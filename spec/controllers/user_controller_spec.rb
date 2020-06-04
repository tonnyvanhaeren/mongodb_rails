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

    it 'should order by lastName && paginate users if pagination params are provided' do
      user1 = create :user, lastName: 'Andries'
      user2 = create :user, lastName: 'Bonapart'
      user3 = create :user, lastName: 'Covits'

      subject
      expect(json_data.length).to eq 3
      expect(json_data.first['attributes']['last-name']).to eq(user1.lastName)
      expect(json_data.last['attributes']['last-name']).to eq(user3.lastName)
      
      get :index, params: { page: 2, per_page: 1 } ## page: from 0,1,2 -> third item
      expect(json_data.length).to eq 1
      expect(json_data.first['attributes']['last-name']).to eq(user3.lastName)
    end
  end

  describe '#show' do
    before { User.delete_all } ### clean database  
    let(:user) { create :user }
    subject {get :show, params: { id: user.id } }

    it 'should return 200 status code when user is found' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json when user is found' do
      subject
      expect(json_data['attributes']).to eq({
        "email" => user.email,
        "first-name" => user.firstName,
        "last-name" => user.lastName,
        "is-accepted" => user.is_accepted,
        "full-name" => "antonius - vanhaeren",
        "is-email-verified" => user.is_email_verified
      })
    end

    it 'should return proper json error when user is not found' do
      get :show, params: { id: 5 }
      expect(json['errors']).to include(
        {
          "code" =>   "404",
          "title" =>  "user with id : 5 not found",
          "detail" => "user id not correct check"
        }
      )
    end

  end

  describe '#create' do 
    subject { post :create, params: params }  

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
      before { User.delete_all } ### clean database
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
    end

  end
end