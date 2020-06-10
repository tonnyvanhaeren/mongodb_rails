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
            "is-email-verified" => user.is_email_verified,
            "role" => "user",
            "created-at" => user.created_at.to_i,
            "updated-at" => user.updated_at.to_i
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
        "is-email-verified" => user.is_email_verified,
        "role" => "user",
        "created-at" => user.created_at.to_i,
        "updated-at" => user.updated_at.to_i
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


end